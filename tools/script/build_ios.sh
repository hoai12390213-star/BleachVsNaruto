#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
FLEX_HOME="${FLEX_HOME:-${REPO_ROOT}/sdk/flex4.16.1-air51.0.1.1}"
IOS_SHELL_DIR="${IOS_SHELL_DIR:-${REPO_ROOT}/SHELL_Ios}"
FALLBACK_SHELL_DIR="${REPO_ROOT}/SHELL_Dev"
TARGET_IPA="${TARGET_IPA:-${REPO_ROOT}/build/BleachVsNaruto-dev.ipa}"
ADT_PACKAGE_TARGET="${ADT_PACKAGE_TARGET:-ipa-debug}"

if [[ -d "${IOS_SHELL_DIR}/src" ]]; then
  APP_ENTRY="${APP_ENTRY:-${IOS_SHELL_DIR}/src/FighterTesterIOS.as}"
  FLEX_CFG="${FLEX_CFG:-${IOS_SHELL_DIR}/flex-config.xml}"
  APP_XML="${APP_XML:-${IOS_SHELL_DIR}/src/FighterTester-app.xml}"
else
  APP_ENTRY="${APP_ENTRY:-${FALLBACK_SHELL_DIR}/src/FighterTester.as}"
  FLEX_CFG="${FLEX_CFG:-${FALLBACK_SHELL_DIR}/flex-config.xml}"
  APP_XML="${APP_XML:-${FALLBACK_SHELL_DIR}/src/FighterTester-app.xml}"
fi

OUT_ROOT="${OUT_ROOT:-${REPO_ROOT}/out/production}"

if [[ -z "${FLEX_HOME}" || ! -d "${FLEX_HOME}/bin" ]]; then
  echo "[ERROR] FLEX_HOME is not configured or missing bin directory: ${FLEX_HOME}"
  exit 1
fi

if [[ ! -f "${APP_ENTRY}" ]]; then
  echo "[ERROR] APP_ENTRY does not exist: ${APP_ENTRY}"
  exit 1
fi

if [[ ! -f "${FLEX_CFG}" ]]; then
  echo "[ERROR] FLEX_CFG does not exist: ${FLEX_CFG}"
  exit 1
fi

if [[ ! -f "${APP_XML}" ]]; then
  echo "[ERROR] APP_XML does not exist: ${APP_XML}"
  exit 1
fi

export PATH="${FLEX_HOME}/bin:${PATH}"

mkdir -p "${OUT_ROOT}"

echo "[INFO] Flex SDK: ${FLEX_HOME}"
echo "[INFO] Entry: ${APP_ENTRY}"
echo "[INFO] Config: ${FLEX_CFG}"

echo "[STEP] Compiling library modules"
for mod in LIB_Other LIB_KyoLib CORE_Shared CORE_Components CORE_KernelLogic CORE_Utils; do
  if [[ -f "${REPO_ROOT}/${mod}/flex-config.xml" ]]; then
    echo "[INFO] Compiling ${mod}"
    compc +configname=air -load-config+="${REPO_ROOT}/tools/script/conf/sdk-external.xml" -load-config+="${REPO_ROOT}/${mod}/flex-config.xml" || {
      echo "[ERROR] Failed to compile ${mod}"
      exit 1
    }
  else
    echo "[WARN] Missing flex-config.xml for ${mod}; skipping"
  fi
done

echo "[STEP] Copying shared assets"
if [[ -d "${REPO_ROOT}/shared" ]]; then
  mkdir -p "${REPO_ROOT}/out/production/SHELL_Dev"
fi

echo "[STEP] Compiling app entry"
amxmlc -load-config+="${FLEX_CFG}" "${APP_ENTRY}" || {
  echo "[ERROR] Failed to compile app entry"
  exit 1
}

mkdir -p "$(dirname "${TARGET_IPA}")"

if [[ -n "${APPLE_CERTIFICATE_PATH:-}" && -n "${APPLE_PROVISIONING_PROFILE_PATH:-}" ]]; then
  echo "[STEP] Packaging AIR app for personal iOS play"
  echo "[INFO] Target: ${ADT_PACKAGE_TARGET}"
  adt -package \
    -target "${ADT_PACKAGE_TARGET}" \
    -storetype pkcs12 \
    -keystore "${APPLE_CERTIFICATE_PATH}" \
    -storepass "${APPLE_CERTIFICATE_PASSWORD:-}" \
    -provisioning-profile "${APPLE_PROVISIONING_PROFILE_PATH}" \
    "${TARGET_IPA}" \
    "${APP_XML}" \
    "${REPO_ROOT}/out/production/SHELL_Ios/FighterTesterIOS.swf"
else
  echo "[INFO] Apple signing is not configured; packaging is skipped."
  echo "[INFO] For a personal IPA, set: APPLE_CERTIFICATE_PATH, APPLE_CERTIFICATE_PASSWORD, APPLE_PROVISIONING_PROFILE_PATH"
  echo "[INFO] Example target: ipa-debug or ipa-test"
fi

echo "[INFO] Build scaffold completed successfully."
echo "[INFO] For personal play, use a development or ad-hoc provisioning profile, not App Store signing."
