supa
===

**S**erver **Up**date **A**

> bash tool to update debian-based linux machines, also means soup in Greek

## usage

```
supa

Usage:
  ./supa.sh <user>@<host> [-h|--help] [-v|--version] [-l|--list] [--list-off]
  [-i|--identity <identity file>] [-u|--upgrade <package>] [-a|--autoremove]
  [-b|--reboot-required] [-r|--reboot] [-d|--debug]

Options:
  -a|--autoremove                                  autoremove
  -b|--reboot-required                             reboot required
  -d|--debug                                       enable debug mode
  -h|--help                                        help
  -i|--identity                                    identity
  -l|--list                                        list
  --list-off                                       list off, only update
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

```

## installation

One way to "install" `supa` is to copy the `supa.sh` script as `supa` to `/usr/local/bin/`.
