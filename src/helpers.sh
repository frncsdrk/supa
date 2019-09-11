#!/usr/bin/env bash
#
# helpers

generate_machines_list() {
  if [ -v MACHINES_FILE ]; then
    machines=$(cat $MACHINES_FILE | grep -v "^$\|^\s*\#")
  else
    machines=($OPERATOR)
  fi
}

get_args() {
  if [[ -z $1 ]]; then
    usage
    exit 0
  fi

  local POSITIONAL=()
  while [[ $# -gt 0 ]]
  do
    local key=$1

    case $key in
      -a|--autoremove)
        AUTOREMOVE=1
        shift
        ;;
      -b|--reboot-required)
        REBOOT_REQUIRED=1
        shift
        ;;
      -D|--debug)
        DEBUG=1
        shift
        ;;
      -h|--help)
        usage
        exit 0
        ;;
      -i|--identity)
        IDENTITY=$2
        shift 2
        ;;
      -l|--list)
        LIST=1
        shift
        ;;
      --list-off)
        LIST_OFF=1
        shift
        ;;
      -m|--machines)
        MACHINES_FILE="$2"
        shift 2
        ;;
      -r|--reboot)
        REBOOT=1
        shift
        ;;
      -u|--upgrade)
        UPGRADE=1
        if [[ $2 != "-"* ]]; then
          UPGRADE_PACKAGE="$2"
          shift 2
        else
          shift
        fi
        ;;
      -V|--version)
        printf '%s\n' "${VERSION}"
        exit 0
        ;;
      self)
        if [[ -z $2 ]]; then
          self_usage
          exit 0
        fi

        local self_key=$2

        case $self_key in
          -h|--help)
            self_usage
            exit 0
            ;;
          rm|remove)
            uninstall
            exit 0
            ;;
          up|upgrade)
            upgrade
            exit 0
            ;;
          *)
            self_usage
            exit 0
            ;;
        esac
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
