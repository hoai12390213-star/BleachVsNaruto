#!/usr/bin/env bash
# Fetch the official (HARMAN) Adobe AIR SDK for macOS.
# This is the compiler-only SDK needed to package an iOS (IPA) build with `adt`.
set -euo pipefail

AIR_SDK_VERSION="${AIR_SDK_VERSION:-51.3.4.1}"
OUT_DIR="${1:-$(pwd)/.cache/airsdk}"
FAST="${FAST:-0}"

mkdir -p "${OUT_DIR}"

# The download page links look like:
#   https://airsdk.harman.com/api/versions/<V>/sdks/AIRSDK_MacOS.zip?id=-1
# `?id=-1` means "I have not accepted the license", which is accepted by the
# site for download (it only blocks unauthorised direct links without ANY id).
if [ "${FAST}" = "1" ]; then
    # Compiler-only SDK (smaller, contains bin/adt + macOS/iOS tooling)
    URL="https://airsdk.harman.com/api/versions/${AIR_SDK_VERSION}/sdks/AIRSDK_MacOS.zip?id=-1"
else
    # Flex + AIR SDK (larger; also contains the full Flex compiler / airglobal.swc)
    URL="https://airsdk.harman.com/api/versions/${AIR_SDK_VERSION}/sdks/AIRSDK_Flex_MacOS.zip?id=-1"
fi

ZIP="${OUT_DIR}/AIRSDK_MacOS.zip"
if [ -f "${ZIP}" ] && [ -d "${OUT_DIR}/sdk" ]; then
    echo "[fetch-sdk] already present: ${OUT_DIR}/sdk"
    exit 0
fi

echo "[fetch-sdk] downloading ${URL}"
curl -fL --retry 3 -C - -o "${ZIP}" "${URL}" \
    -H "User-Agent: Mozilla/5.0"

echo "[fetch-sdk] extracting"
rm -rf "${OUT_DIR}/sdk.tmp"
mkdir -p "${OUT_DIR}/sdk.tmp"
unzip -q "${ZIP}" -d "${OUT_DIR}/sdk.tmp"

# Harman zips usually contain a single top-level dir (e.g. `AIRSDK_MacOS`).
REAL="$(find "${OUT_DIR}/sdk.tmp" -maxdepth 2 -name adt -o -maxdepth 2 -name adt.bat | head -1 || true)"
if [ -z "${REAL}" ]; then
    echo "[fetch-sdk] ERROR: no adt found in archive"
    exit 1
fi
SDK_ROOT="$(dirname "$(dirname "${REAL}")")"
rm -rf "${OUT_DIR}/sdk"
mv "${SDK_ROOT}" "${OUT_DIR}/sdk"

chmod +x "${OUT_DIR}/sdk/bin/"* 2>/dev/null || true
echo "[fetch-sdk] done: ${OUT_DIR}/sdk"
"${OUT_DIR}/sdk/bin/adt" -version