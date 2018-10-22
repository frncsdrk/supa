supa
===

**S**erver **Up**date **A**

> bash tool to update linux servers, also means soup in Greek

## usage

```
supa

Usage:
  ./supa.sh -o <user>@<host> [-h|--help] [-u|--upgrade <package>] [-a|--autoremove] [-r|--reboot] [-v|--version]

Options:
  -a|--autoremove                                  autoremove
  -h|--help                                        help
  -o|--operator                                    operator
  -r|--reboot                                      reboot
  -u|--upgrade                                     upgrade
  -v|--version                                     version

Examples:
  ./supa.sh -h                                     display this message
  ./supa.sh -o you@remote-host                     run apt update and apt list --upgradeable
  ./supa.sh -o you@remote-host -u                  same as the former but with the addition of upgrading all packages
  ./supa.sh -o you@remote-host -u <package>        same as the former but with the addition of upgrading one single package
  ./supa.sh -o you@remote-host -u -r               same as the former but with the addition of allowing reboot if necessary
  ./supa.sh -o you@remote-host -u -a -r            same as the former but with the addition of autoremoving of obsolete packages

```

## installation

One way to "install" `supa` is to copy the `supa.sh` script as `supa` to `/usr/local/bin/`.
