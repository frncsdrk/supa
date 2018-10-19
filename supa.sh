#!/usr/bin/env bash

VERSION="v0.2.1"

usage() {
  cat << EOF
supa

Usage: ./supa.sh -o <user>@<host> [-h help] [-u upgrade] [-p package] [-a autoremove] [-r reboot] [-v version]

Options:
  -a                                               autoremove
  -h                                               help
  -o                                               operator
  -p                                               package
  -r                                               reboot
  -u                                               upgrade
  -v                                               version

Examples:
  ./supa.sh -h                                     display this message
  ./supa.sh -o you@remote-host                     run apt update and apt list --upgradeable
  ./supa.sh -o you@remote-host -u                  same as the former but with the addition of upgrading all packages
  ./supa.sh -o you@remote-host -u -p [package]     same as the former but with the addition of upgrading one single package
  ./supa.sh -o you@remote-host -u -r               same as te former but with the addition of allowing reboot if necessary
  ./supa.sh -o you@remote-host -u -a -r            same as te former but with the addition of autoremoving of obsolete packages

EOF
}

while getopts "aho:pru:v" option
do
  case "${option}"
  in
    a)
      AUTOREMOVE=${OPTIND}
      ;;
    h)
      usage
      exit 0
      ;;
    o)
      OPERATOR=${OPTARG}
      ;;
    p)
      UPGRADE_PACKAGE=${OPTARG}
      ;;
    r)
      REBOOT=${OPTIND}
      ;;
    u)
      UPGRADE=${OPTIND}
      ;;
    v)
      echo "$VERSION"
      exit 0
      ;;
  esac
done

SCRIPT=$'sudo apt update'
SCRIPT+=$'\napt list --upgradeable'
if [ ! -z "$UPGRADE" ]; then
  if [ ! -z "$UPGRADE_PACKAGE" ]; then
    SCRIPT+=$'\nsudo apt install --only-upgrade '
    SCRIPT+="$UPGRADE_PACKAGE"
  else
    SCRIPT+=$'\nsudo apt upgrade -y'
  fi
fi
if [ ! -z "$AUTOREMOVE" ]; then
  SCRIPT+=$'\nsudo apt autoremove'
fi
if [ ! -z "$REBOOT" ]; then
  SCRIPT+=$'\nif [ -f "/var/run/reboot-required" ]; then'
  SCRIPT+=$'\n  sudo /sbin/reboot now'
  SCRIPT+=$'\nfi'
fi

ssh "$OPERATOR" "$SCRIPT"
