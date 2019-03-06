#!/usr/bin/env bash
#
# setup script for supa.sh

INSTALLABLE_NAME="supa.sh"

usage() {
  cat << EOF
setup

Synopsis:
  ./setup <i|install|u|uninstall|upgrade>

Commands:
  i|install
          install supa.sh and create its manpage
  u|uninstall
          uninstall supa.sh and remove its manpage
  upgrade
          update manpage
EOF
}

# ensure linux
check_os() {
  if [[ "$OSTYPE" == "linux-gnu" ]] || [[ "$OSTYPE" == "linux-musl" ]] ; then
    readonly _dir=$(dirname "$(readlink -f "$0" || echo "$(echo "$0" | sed -e 's,\\,/,g')")")
  else
    printf "Unsupported system\\n"
    exit 1
  fi
}

get_args() {
  if [[ -z $1 ]]; then
    usage
  fi

  local POSITIONAL=()
  while [[ $# -gt 0 ]]
  do
    local key=$1

    case $key in
      -h|--help)
        usage
        exit 0
        ;;
      i|install)
        install
        exit 0
        ;;
      u|uninstall)
        uninstall
        exit 0
        ;;
      upgrade)
        upgrade
        exit 0
        ;;
      -v|--version)
        printf '%s\n' "$VERSION"
        exit 0
        ;;
      *)
        # get operator
        if [[ $1 =~ ^.+@.+$ ]]; then
          OPERATOR="$1"
        fi
        POSITIONAL+=("$1")
        shift
        ;;
    esac
  done
  set -- "${POSITIONAL[@]}"
}

install_manpage() {
  printf "%s\\n" "Create man page to /usr/local/man/man8"

  if [[ -e "${_dir}/static/man8/${INSTALLABLE_NAME}.8" ]] ; then
    if [[ ! -e "/usr/local/man/man8/${INSTALLABLE_NAME}.8.gz" ]] ; then
      mkdir -p /usr/local/man/man8
      cp "${_dir}/static/man8/${INSTALLABLE_NAME}.8" /usr/local/man/man8
      gzip /usr/local/man/man8/${INSTALLABLE_NAME}.8
    fi
  fi
}

install() {
  printf "%s\\n" "Create symbolic link to /usr/local/bin"

  if [[ -e "${_dir}/bin/${INSTALLABLE_NAME}" ]] ; then
    if [[ ! -e "/usr/local/bin/${INSTALLABLE_NAME}" ]] ; then
      ln -s "${_dir}/bin/${INSTALLABLE_NAME}" /usr/local/bin
    fi
  fi

  install_manpage
}

uninstall_manpage() {
  printf "%s\\n" "Remove man page from /usr/local/man/man8"

  if [[ -e "/usr/local/man/man8/${INSTALLABLE_NAME}.8.gz" ]] ; then
    rm /usr/local/man/man8/${INSTALLABLE_NAME}.8.gz
  fi
}

uninstall() {
  printf "%s\\n" "Remove symbolic link from /usr/local/bin"

  if [[ -L "/usr/local/bin/${INSTALLABLE_NAME}" ]] ; then
    unlink /usr/local/bin/${INSTALLABLE_NAME}
  fi

  uninstall_manpage
}

upgrade() {
  printf "%s\\n" "Replace man page from /usr/local/man/man8"

  uninstall_manpage
  install_manpage
}

main() {
  check_os
  get_args "$@"
}

main "$@"
