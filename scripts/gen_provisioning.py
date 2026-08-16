#!/usr/bin/env python3
"""Fabricate a minimal (fake) iOS provisioning profile for sideload builds.

A .mobileprovision is a CMS SignedData blob whose "content" is a plist dict.
For TrollStore installs this profile is never validated against Apple; the
device re-signs on install. It only has to parse correctly inside `codesign` /
`adt` so the build toolchain is happy.

Usage:
    gen_provisioning.py <bundle-id> <dev.der> <dev.key> <out.mobileprovision>
"""
import hashlib
import os
import plistlib
import subprocess
import sys
import time
import uuid
from datetime import datetime, timedelta


def der_len(value_len: int) -> int:
    if value_len < 0x80:
        return 1
    if value_len <= 0xFF:
        return 2
    if value_len <= 0xFFFF:
        return 3
    return 4


def der_len_bytes(value_len: int) -> bytes:
    if value_len < 0x80:
        return bytes([value_len])
    if value_len <= 0xFF:
        return b'\x81' + bytes([value_len])
    if value_len <= 0xFFFF:
        return b'\x82' + value_len.to_bytes(2, 'big')
    return b'\x83' + value_len.to_bytes(3, 'big')


def tlv(tag: int, content: bytes) -> bytes:
    return bytes([tag]) + der_len_bytes(len(content)) + content


def seq(*parts: bytes) -> bytes:
    return tlv(0x30, b''.join(parts))


def integer(n: int) -> bytes:
    if n == 0:
        return tlv(0x02, b'\x00')
    raw = n.to_bytes((n.bit_length() + 7) // 8, 'big')
    return tlv(0x02, raw)


def oid(*arcs) -> bytes:
    if len(arcs) < 2:
        raise ValueError('OID needs at least two arcs')
    body = bytearray([arcs[0] * 40 + arcs[1]])
    for a in arcs[2:]:
        chunks = [a & 0x7F]
        rest = a >> 7
        while rest:
            chunks.append(rest & 0x7F)
            rest >>= 7
        for i, chunk in enumerate(reversed(chunks)):
            body.append(chunk | (0x80 if i < len(chunks) - 1 else 0))
    return tlv(0x06, bytes(body))


def parse_tlv(data: bytes, off: int = 0):
    tag = data[off]
    off += 1
    ln = data[off]
    off += 1
    if ln & 0x80:
        n = ln & 0x7F
        ln = int.from_bytes(data[off:off + n], 'big')
        off += n
    return tag, data[off:off + ln], off + ln


def cert_issuer_and_serial(cert_der: bytes):
    tag, body, _ = parse_tlv(cert_der)
    _, tbs, _ = parse_tlv(body)
    # TBS: version? v3 has version (explicit [0]), then serial, then signature, subject...
    off = 0
    if body[off] == 0xA0:
        _, skip, off = parse_tlv(body, off)  # version [0] (tag 0xa0)
    _, serial_raw, off = parse_tlv(body, off)
    _, sig_alg_raw, off = parse_tlv(body, off)
    _, issuer_raw, off = parse_tlv(body, off)
    return issuer_raw, serial_raw.hex()


def main():
    if len(sys.argv) != 5:
        print(__doc__)
        sys.exit(2)
    bundle_id, cert_der_path, key_path, out_path = sys.argv[1:5]

    with open(cert_der_path, 'rb') as f:
        cert_der = f.read()

    now = datetime.now()
    expiry = now + timedelta(days=3650)
    profile_uuid = str(uuid.uuid4()).upper()

    entitlements = {
        'application-identifier': f'0000000000.{bundle_id}',
        'keychain-access-groups': [f'0000000000.{bundle_id}'],
        'get-task-allow': True,
    }
    profile = {
        'AppIDName': 'BVN iOS Personal',
        'ApplicationIdentifierPrefix': ['0000000000'],
        'CreationDate': now,
        'Platform': ['iOS'],
        'IsXCCompatible': True,
        'DeveloperCertificates': [cert_der],
        'Entitlements': entitlements,
        'ExpirationDate': expiry,
        'Name': 'BVN iOS Personal Sideload',
        'ProvisionedDevices': ['00000000-000000000000100000000001'],
        'TeamIdentifier': ['00000000'],
        'TimeToLive': 3650,
        'UUID': profile_uuid,
        'Version': 1,
    }
    plist = plistlib.dumps(profile)

    # RSA-SHA256 signature over the plist, computed with openssl
    sig = subprocess.run(
        ['openssl', 'dgst', '-sha256', '-sign', key_path],
        input=plist, capture_output=True,
    ).stdout

    issuer, serial = cert_issuer_and_serial(cert_der)

    # --- SignerInfo ---------------------------------------------------------
    sid = tlv(0x30, issuer + integer(int(serial, 16)))
    signer_info = seq(
        integer(1),                       # version
        sid,                              # sid (issuerAndSerialNumber)
        seq(oid(2, 16, 840, 1, 101, 3, 4, 2, 1)),   # digestAlg = sha256
        seq(oid(1, 2, 840, 113549, 1, 1, 11)),       # sigAlg = sha256WithRSA
        tlv(0x04, sig),                   # signature
    )
    signer_infos = tlv(0x31, signer_info)

    # --- CertificateSet [0] -------------------------------------------------
    certs = tlv(0xA0, cert_der)

    # --- EncapsulatedContentInfo --------------------------------------------
    encap = seq(
        oid(1, 2, 840, 113549, 1, 7, 1),  # data
        tlv(0xA0, tlv(0x04, plist)),      # [0] EXPLICIT OCTET STRING
    )

    signed_data = seq(
        integer(1),                                  # version
        tlv(0x31, seq(oid(2, 16, 840, 1, 101, 3, 4, 2, 1))),  # digestAlgorithms
        encap,
        certs,
        signer_infos,
    )

    content_info = seq(oid(1, 2, 840, 113549, 1, 7, 2), tlv(0xA0, signed_data))

    with open(out_path, 'wb') as f:
        f.write(content_info)
    print(f'wrote {out_path}')


if __name__ == '__main__':
    main()