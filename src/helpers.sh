#!/usr/bin/env bash
#
# helpers

usage() {
  cat << EOF
supa

Usage:
  ./supa.sh <user>@<host> [-h|--help] [-v|--version] [-l|--list] [--list-off]
  [-i|--identity <identity file>] [-u|--upgrade <package>] [-a|--autoremove] [-m|--machines]
  [-b|--reboot-required] [-r|--reboot] [-d|--debug]

Options:
  -a|--autoremove
          autoremove

  -b|--reboot-required
          reboot required

  -d|--debug
          enable debug mode

  -h|--help
          show this message

  -i|--identity
          identity

  -l|--list
          list

  --list-off
          list off, only update

  -m|--machines
          use given machines file

  -r|--reboot
          reboot

  -u|--upgrade
          upgrade

  -v|--version
          version

Examples:
  supa.sh -v
          display version

  supa.sh -h
          display this message

  supa.sh you@remote-host -b
          is machine reboot required

  supa.sh you@remote-host -b -l
          is machine reboot required, but list upgradeable packages as well

  supa.sh -m production -b -l
          same as previous but use machines file

  supa.sh you@remote-host
          run apt update and apt list --upgradeable

  supa.sh you@remote-host -u
          same as the former but with the addition of upgrading all packages

  supa.sh you@remote-host -u <package>
          same as the former but with the addition of upgrading one single package

  supa.sh you@remote-host -u -r
          same as the former but with the addition of allowing reboot if necessary

  supa.sh you@remote-host -u -a -r
          same as the former but with the addition of autoremoving of obsolete packages

EOF
}

generate_machines_list() {
  if [ -v MACHINES_FILE ]; then
    machines=$(cat $MACHINES_FILE | grep -v "^$\|^\s*\#")
  else
    machines=($OPERATOR)
  fi
}

get_args() {
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
      -d|--debug)
        DEBUG=1
        shift
        ;;
      -h|--help)
        usage
        exit 0
        ;;
      -i|--identity)
        IDENTITY=$2
        shift
        shift
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
        shift
        shift
        ;;
      -r|--reboot)
        REBOOT=1
        shift
        ;;
      -u|--upgrade)
        UPGRADE=1
        if [[ $2 != "-"* ]]; then
          UPGRADE_PACKAGE="$2"
        fi
        shift
        shift
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
