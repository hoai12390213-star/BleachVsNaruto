#!/usr/bin/env bash
# Generate a self-signed iOS code-signing identity (for TrollStore / sideload use).
# TrollStore re-signs the app on the device, so the certificate only needs to
# exist for the build toolchain; it does NOT need to be an Apple identity.
#
# NOTE: adt's MachoSigner requires an OU (Organizational Unit) RDN in the cert
# subject - it uses it as the code-signing "team identifier". Without OU, adt
# fails with "ADT exception: Using old Signing Certificate."
#
# Preferred path: let `adt -certificate` mint the PKCS#12 itself, which
# guarantees Java/adt can read it back (system OpenSSL/LibreSSL may default to
# AES/PBKDF2 p12 encryption that older Java stacks reject as a bad password).
set -euo pipefail

OUT="${1:-$(pwd)/.cache/sign}"
PASS="bvn-ios"
mkdir -p "${OUT}"

if [ -f "${OUT}/dev.p12" ]; then
    echo "[gen-cert] already exists"
    exit 0
fi

ADT_BIN="${ADT_BIN:-}"
if [ -n "${ADT_BIN}" ] && [ -x "${ADT_BIN}" ]; then
    echo "[gen-cert] generating via adt -certificate"
    "${ADT_BIN}" -certificate \
        -cn "BVN iOS Side-load" \
        -ou "BVNTEAM" \
        -o "Personal" \
        -c "US" \
        -validityPeriod 10 \
        2048-RSA "${OUT}/dev.p12" "${PASS}"
    # Extract PEM key + DER cert from the p12 for gen_provisioning.py
    openssl pkcs12 -in "${OUT}/dev.p12" -passin "pass:${PASS}" -nodes \
        -nokeys -out "${OUT}/dev.crt"
    openssl x509 -in "${OUT}/dev.crt" -outform der -out "${OUT}/dev.der"
    openssl pkcs12 -in "${OUT}/dev.p12" -passin "pass:${PASS}" -nodes \
        -nocerts -nodes -out "${OUT}/dev.key"
else
    echo "[gen-cert] generating via openssl (legacy-compatible p12)"
    # 1) RSA key + self-signed X.509 certificate (SHA-256)
    openssl req -x509 -newkey rsa:2048 -nodes -sha256 \
        -keyout "${OUT}/dev.key" \
        -out "${OUT}/dev.crt" \
        -subj "/CN=BVN iOS Side-load/O=Personal/C=US/OU=BVNTEAM" \
        -addext "basicConstraints=critical,CA:FALSE" \
        -addext "keyUsage=critical,digitalSignature" \
        -addext "extendedKeyUsage=codeSigning" \
        -days 3650 2>/dev/null

    # 2) DER form for the provisioning profile
    openssl x509 -in "${OUT}/dev.crt" -outform der -out "${OUT}/dev.der"

    # 3) PKCS#12 keystore with legacy 3DES/SHA-1 PBE so old Java keystores
    #    can open it (OpenSSL 3 defaults to AES-256/PBKDF2 which some reject)
    openssl pkcs12 -export \
        -inkey "${OUT}/dev.key" -in "${OUT}/dev.crt" \
        -out "${OUT}/dev.p12" \
        -keypbe PBE-SHA1-3DES -certpbe PBE-SHA1-3DES -macalg sha1 \
        -passout "pass:${PASS}"
fi

echo "[gen-cert] done: ${OUT}/dev.p12 (pass: ${PASS})"
