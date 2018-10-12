#!/usr/bin/env bash

VERSION="v0.1.1"

usage() {
  cat << EOF
supa

Usage: ./supa.sh -o <user>@<host> [-h help] [-u upgrade] [-r reboot]

Options:
  -h                                   help
  -u                                   upgrade
  -r                                   reboot
  -v                                   version

Examples:
  ./supa.sh -h                         display this message
  ./supa.sh -o you@remote-host         run apt update and apt list --upgradeable
  ./supa.sh -o you@remote-host -u      same as the former but with the addition of upgrading all packages
  ./supa.sh -o you@remote-host -u -r   same as te former but with the addition of allowing reboot if necessary

EOF
}

while getopts "ho:ruv" option
do
  case "${option}"
  in
    h)
      usage
      exit 0
      ;;
    o)
      OPERATOR=${OPTARG}
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
  SCRIPT+=$'\nsudo apt upgrade -y'
fi
if [ ! -z "$REBOOT" ]; then
  SCRIPT+=$'\nif [ -f "/var/run/reboot-required" ]; then'
  SCRIPT+=$'\n  sudo /sbin/reboot now'
  SCRIPT+=$'\nfi'
fi

ssh "$OPERATOR" "$SCRIPT"
