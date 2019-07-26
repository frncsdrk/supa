#!/usr/bin/env bash
#
# installer

# ensure linux or darwin
check_os() {
  if [[ "$OSTYPE" == "linux-gnu" ]] || [[ "$OSTYPE" == "linux-musl" ]] || [[ "$OSTYPE" == "darwin" ]] ; then
    readonly _dir=$(dirname "$(readlink -f "$0" || echo "$(echo "$0" | sed -e 's,\\,/,g')")")
  else
    printf '%s\n' "Unsupported system"
    exit 1
  fi
}

uninstall_manpage() {
  printf '%s\n' "Remove man page from /usr/local/man/man8"

  if [[ -e "/usr/local/man/man8/${INSTALLABLE_NAME}.8.gz" ]]; then
    rm /usr/local/man/man8/${INSTALLABLE_NAME}.8.gz
  fi
}

uninstall() {
  printf '%s\n' "Remove installation"

  if [[ -d "${INSTALL_DIRECTORY_PATH}/${INSTALLABLE_NAME}" ]]; then
    rm -r "${INSTALL_DIRECTORY_PATH}/${INSTALLABLE_NAME}"
  fi

  printf '%s\n' "Remove symbolic link from /usr/local/bin"

  if [[ -L "/usr/local/bin/${INSTALLABLE_NAME}" ]]; then
    unlink /usr/local/bin/${INSTALLABLE_NAME}
  fi

  uninstall_manpage
}

upgrade() {
  local tmp_script_location="/tmp/supa-download.sh"

  printf '%s\n' "Upgrading supa.sh to latest version"

  if [[ ! -d /tmp ]]; then
    mkdir /tmp
  fi

  printf '%s\n' "Creating temporary supa.sh download script as ${tmp_script_location}"
  cp "${INSTALL_DIRECTORY_PATH}/${INSTALLABLE_NAME}/download.sh" "${tmp_script_location}"

  uninstall
  source "${tmp_script_location}"

  printf '%s\n' "Removing temporary supa.sh download script"
  rm "${tmp_script_location}"
}
