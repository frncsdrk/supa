#!/usr/bin/env bash
#
# download script for supa.sh

source "./src/settings.sh"

download() {
  if [[ ! -d /tmp ]]; then
    mkdir /tmp
  fi

  cd /tmp

  if [[ ! -x "$(command -v wget)" ]]; then
    printf '%s\n' "please install wget to download ${INSTALLABLE_NAME}"
  fi

  if [[ ! -d "${INSTALLABLE_NAME}" ]]; then
    mkdir "${INSTALLABLE_NAME}"
  fi

  local TAR_TARGET="${INSTALLABLE_NAME}.tar.gz"
  wget -q "${DOWNLOAD_URL}" -O "${TAR_TARGET}"
  tar -xzf "${TAR_TARGET}"
  rm "${TAR_TARGET}"

  printf '%s\n' "installing to /opt"

  if [[ -d "/opt/${INSTALLABLE_NAME}" ]]; then
    rm -r "/opt/${INSTALLABLE_NAME}"
  fi
  mv "${EXTRACTED_DIR_NAME}" "/opt/${INSTALLABLE_NAME}"

  cd "/opt/${INSTALLABLE_NAME}"
  ./setup.sh i

  printf '%s\n' "DONE"
}

main() {
  download
}

main "$@"
exit 0
