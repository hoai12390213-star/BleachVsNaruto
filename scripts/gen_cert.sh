#!/usr/bin/env bash
# Generate a self-signed iOS code-signing identity (for TrollStore / sideload use).
# TrollStore re-signs the app on the device, so the certificate only needs to
# exist for the build toolchain; it does NOT need to be an Apple identity.
set -euo pipefail

OUT="${1:-$(pwd)/.cache/sign}"
mkdir -p "${OUT}"

if [ -f "${OUT}/dev.p12" ]; then
    echo "[gen-cert] already exists"
    exit 0
fi

# 1) RSA key + self-signed X.509 certificate
# NOTE: adt's MachoSigner requires an OU (Organizational Unit) RDN in the
# subject - it uses it as the code-signing "team identifier". Without OU,
# adt fails with "ADT exception: Using old Signing Certificate."
openssl req -x509 -newkey rsa:2048 -nodes -sha256 \
    -keyout "${OUT}/dev.key" \
    -out "${OUT}/dev.crt" \
    -subj "/CN=BVN iOS Side-load/O=Personal/C=US/OU=BVNTEAM" \
    -addext "basicConstraints=critical,CA:FALSE" \
    -addext "keyUsage=critical,digitalSignature" \
    -addext "extendedKeyUsage=codeSigning" \
    -days 3650 2>/dev/null

# 2) DER forms the tooling wants
openssl x509 -in "${OUT}/dev.crt" -outform der -out "${OUT}/dev.der"

# 3) PKCS#12 keystore (used by `adt -keystore`)
openssl pkcs12 -export \
    -inkey "${OUT}/dev.key" -in "${OUT}/dev.crt" \
    -out "${OUT}/dev.p12" \
    -passout pass:bvn-ios

echo "[gen-cert] done: ${OUT}/dev.p12 (pass: bvn-ios)"