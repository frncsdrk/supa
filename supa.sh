#!/usr/bin/env bash

usage() { echo "Usage: ./supa.sh -o <user>@<host> [-h help] [-u upgrade] [-r reboot]"; }

while getopts "ho:ru" option
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
