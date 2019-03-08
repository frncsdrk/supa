#!/usr/bin/env bash
#
# supa - *S*erver *Up*date *A*

# call parameters
__script_params=("$@")

if [[ "$OSTYPE" == "linux-gnu" ]] || [[ "$OSTYPE" == "linux-musl" ]] ; then
  # store name of the script and directory call
  readonly _init_name="$(basename "$0")"
  readonly _init_directory=$(dirname "$(readlink -f "$0" || echo "$(echo "$0" | sed -e 's,\\,/,g')")")
else
  printf "Unsupported system\\n"
  exit 1
fi

# set root directory
readonly _rel="${_init_directory}/.."

source "${_rel}/setup.sh"

# directories
readonly _src="${_rel}/src"

source "${_src}/helpers.sh"
source "${_src}/main.sh"

readonly VERSION="v0.12.5"

main "${__script_params[@]}"

exit 0
