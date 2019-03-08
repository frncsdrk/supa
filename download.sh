#!/usr/bin/env bash
#
# download script for supa.sh

INSTALLABLE_NAME="supa.sh"
DOWNLOAD_URL="https://github.com/frncsdrk/supa.sh/archive/master.tar.gz"
EXTRACTED_DIR_NAME="${INSTALLABLE_NAME}-master"

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
    sudo rm -r "/opt/${INSTALLABLE_NAME}"
  fi
  sudo mv "${EXTRACTED_DIR_NAME}" "/opt/${INSTALLABLE_NAME}"

  cd "/opt/${INSTALLABLE_NAME}"
  sudo ./setup.sh i

  printf '%s\n' "DONE"
}

main() {
  download
}

main "$@"
exit 0
