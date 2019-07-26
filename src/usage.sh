#!/usr/bin/env bash
#
# usage

usage() {
  cat << EOF
supa.sh

Usage:
  supa.sh <user>@<host> [-h|--help] [-V|--version] [-l|--list] [--list-off]
  [-i|--identity <identity file>] [-u|--upgrade [package] [-a|--autoremove] [-m|--machines]
  [-b|--reboot-required] [-r|--reboot] [-D|--debug]

  supa.sh self

Options:
  -a|--autoremove
          autoremove

  -b|--reboot-required
          reboot required

  -D|--debug
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

  -V|--version
          version

  self
          self command

Examples:
  supa.sh -V
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

  supa.sh self upgrade
          upgrade supa.sh to newest version

EOF
}

self_usage() {
  cat << EOF
supa.sh self

Usage:
  supa.sh self <rm|remove|up|upgrade>

Commands:
  rm|remove
          uninstall supa.sh and remove its manpage

  upgrade
          update manpage

EOF
}
