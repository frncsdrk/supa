#!/usr/bin/env bash

VERSION="v0.8.0"

usage() {
  cat << EOF
supa

Usage:
  ./supa.sh <user>@<host> [-h|--help] [-v|--version] [-l|--list]
  [-u|--upgrade <package>] [-a|--autoremove] [-b|reboot-required] [-r|--reboot]

Options:
  -a|--autoremove                                  autoremove
  -b|--reboot-required                             reboot required
  -h|--help                                        help
  -l|--list                                        list
  -r|--reboot                                      reboot
  -u|--upgrade                                     upgrade
  -v|--version                                     version

Examples:
  ./supa.sh -v                                     display version
  ./supa.sh -h                                     display this message
  ./supa.sh -b                                     is machine reboot required
  ./supa.sh -b -l                                  is machine reboot required, but list upgradeable packages as well
  ./supa.sh you@remote-host                        run apt update and apt list --upgradeable
  ./supa.sh you@remote-host -u                     same as the former but with the addition of upgrading all packages
  ./supa.sh you@remote-host -u <package>           same as the former but with the addition of upgrading one single package
  ./supa.sh you@remote-host -u -r                  same as the former but with the addition of allowing reboot if necessary
  ./supa.sh you@remote-host -u -a -r               same as the former but with the addition of autoremoving of obsolete packages

EOF
}

POSITIONAL=()
while [[ $# -gt 0 ]]
do
  key=$1

  case $key in
    -a|--autoremove)
      AUTOREMOVE=1
      shift
      ;;
    -b|--reboot-required)
      REBOOT_REQUIRED=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    -l|--list)
      LIST=1
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
      echo "$VERSION"
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

SCRIPT="# supa $VERSION"

if [ -z "$REBOOT_REQUIRED" ] || [ ! -z "$LIST" ]; then
  SCRIPT+=$'\nsudo apt update'
  SCRIPT+=$'\napt list --upgradeable'
fi
if [ ! -z "$UPGRADE" ]; then
  if [ ! -z "$UPGRADE_PACKAGE" ]; then
    SCRIPT+=$'\nsudo apt install --only-upgrade '
    SCRIPT+="$UPGRADE_PACKAGE"
  else
    SCRIPT+=$'\nsudo apt upgrade -y'
  fi
fi
if [ ! -z "$AUTOREMOVE" ]; then
  SCRIPT+=$'\nsudo apt -y autoremove'
fi
if [ ! -z "$REBOOT" ] || [ ! -z "$REBOOT_REQUIRED" ]; then
  SCRIPT+=$'\nif [ -f "/var/run/reboot-required" ]; then'
  if [ ! -z "$REBOOT_REQUIRED" ]; then
    SCRIPT+=$'\n  echo "machine reboot required"'
  fi
  if [ ! -z "$REBOOT" ]; then
    SCRIPT+=$'\n  sudo /sbin/reboot now'
  fi
  SCRIPT+=$'\nfi'
fi

ssh "$OPERATOR" "$SCRIPT"
