#!/usr/bin/env bash
# Build an IPA for TrollStore from the official Android APK.
#
# Prereqs: AIR SDK (scripts/fetch_sdk.sh), an input APK, macOS (Xcode).
set -euo pipefail

SDK_DIR="${SDK_DIR:-$(pwd)/.cache/airsdk/sdk}"
APK="${APK:-}"
WORK="${WORK:-$(mktemp -d)}"
BUNDLE_ID="${BUNDLE_ID:-net.play5d.game.bvn.ios}"
SIGN_DIR="${SIGN_DIR:-$(pwd)/.cache/sign}"
OUT_DIR="${OUT_DIR:-$(pwd)/dist}"

ADT="${SDK_DIR}/bin/adt"
[ -x "${ADT}" ] || { echo "adt not found at ${ADT}; run scripts/fetch_sdk.sh first"; exit 1; }
[ -n "${APK}" ] && [ -f "${APK}" ] || { echo "APK not provided/found: ${APK}"; exit 1; }

mkdir -p "${WORK}" "${OUT_DIR}"

echo "== [1/5] Fetching ad-hoc signing identity + fake provisioning profile"
bash "$(dirname "$0")/gen_cert.sh" "${SIGN_DIR}"
PY=$(command -v python3 || command -v python)
"${PY}" "$(dirname "$0")/gen_provisioning.py" \
    "${BUNDLE_ID}" \
    "${SIGN_DIR}/dev.der" "${SIGN_DIR}/dev.key" \
    "${WORK}/embedded.mobileprovision"

echo "== [2/5] Extracting APK"
"${PY}" "$(dirname "$0")/extract_apk.py" "${APK}" "${WORK}/content"

echo "== [3/5] Building iOS icon set (using macOS sips)"
ICON_SRC="$(python3 -c "
import glob,os
cands=[]
cands += sorted(glob.glob(os.path.join('${WORK}','content','icons','*.png')), key=os.path.getsize, reverse=True)
cands += ['${WORK}/content/assets/title.png','${WORK}/content/assets/loading.png']
for c in cands:
    if os.path.exists(c):
        print(c); break
")"
echo "icon source: ${ICON_SRC}"
mkdir -p "${WORK}/content/icon"
for sz in 57 72 114 120 144 152 180; do
  sips -z ${sz} ${sz} "${ICON_SRC}" --out "${WORK}/content/icon/icon-${sz}.png" >/dev/null
done
echo "icons done"

echo "== [4/5] Packaging with adt"
# Lay out the app payload: launch.swf + assets/ + icon/
rm -rf "${WORK}/payload" && mkdir -p "${WORK}/payload"
cp "${WORK}/content/main.swf" "${WORK}/payload/launch.swf"
cp -r "${WORK}/content/assets" "${WORK}/payload/assets"
cp -r "${WORK}/content/icon" "${WORK}/payload/icon"

# App descriptor: <content>launch.swf</content>
cp "$(dirname "$0")/../ios/launch-app-ios.xml" "${WORK}/ios-launch.xml"
cd "${WORK}/payload"

set +e
# Strategy 1: ad-hoc signed IPA (no real identity / no Apple cert needed).
"${ADT}" -package -target ipa-ad-hoc -storetype adhoc \
    -platforms ios-arm64 \
    -provisioning-profile "${WORK}/embedded.mobileprovision" \
    "${WORK}/output.ipa" "${WORK}/ios-launch.xml" \
    launch.swf assets icon 2>&1 | tee "${WORK}/adt.log"
ADT_RC=$?

if [ ${ADT_RC} -ne 0 ]; then
    echo "== ipa-ad-hoc failed; trying ipa-test (keystore + fake provisioning)"
    "${ADT}" -package -target ipa-test-interpreter \
        -keystore "${SIGN_DIR}/dev.p12" -storepass bvn-ios -storetype pkcs12 \
        -provisioning-profile "${WORK}/embedded.mobileprovision" \
        -platforms ios-arm64 \
        "${WORK}/output.ipa" "${WORK}/ios-launch.xml" \
        launch.swf assets icon 2>&1 | tee "${WORK}/adt2.log"
    ADT_RC=$?
fi
set -e

if [ ${ADT_RC} -ne 0 ] || [ ! -f "${WORK}/output.ipa" ]; then
    echo "== ERROR: adt packaging failed (see logs above)"
    exit 1
fi

echo "== [5/5] Done"
mv "${WORK}/output.ipa" "${OUT_DIR}/BVN.ipa"
ls -lh "${OUT_DIR}/BVN.ipa"
echo "SUCCESS -> ${OUT_DIR}/BVN.ipa (fake-signed; install via TrollStore)"