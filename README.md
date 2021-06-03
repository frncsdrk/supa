# supa.sh

**S**erver **Up**date with **A**pt

> bash tool to update debian-based linux machines, also means soup in Greek

## Usage

```
supa.sh

Usage:
  supa.sh <user>@<host> [-D|--debug] [-h|--help] [-i|--identity <identity file>]
  [-l|--list] [--list-off] [-a|--autoremove] [-u|--upgrade [package]] [-m|--machines]
  [-b|--reboot-required] [-r|--reboot] [-v|--verbose] [-V|--version]

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

  -v|--verbose
          set verbose

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

```

### Reboot and reboot-required flags

When using the `reboot` or `reboot-required` flag updating and listing of upgradable packages is turned off by default.
It can be turned on by using the `list` flag.

### Machines file

```sh
# my awesome host
me@remote-host
# my second awesome host
me@remote-host2
```

## Bugs

### grub

Updating grub with `supa.sh` is potentially dangerous and can leave your machine unbootable.
I strongly recommend looking out for grub updates and apply them manually to the machine.

## Installation

### automatically

Run `curl https://raw.githubusercontent.com/frncsdrk/supa.sh/master/download.sh -sSf | sudo bash`

### manually

- clone the repo
- run `./setup.sh i` (requires `sudo`)

## Docker

Use `docker run frncsdrk/supa.sh`

## Development

### Release preparation

Update version number (and date) in following files

- `download.sh`
- `bin/supa.sh`
- `static/man8/supa.sh.man8`

## License

[MIT](https://github.com/frncsdrk/supa.sh/blob/master/LICENSE) (c) frncsdrk 2018 - 2021
