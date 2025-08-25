#!/bin/bash

# stdlib testing protect component

builtin set -eo pipefail

_STDLIB_TESTING_STDLIB_PROTECT_PREFIX=""

__testing.protect_stdlib() {
  local stdlib_library_prefix="${_STDLIB_TESTING_STDLIB_PROTECT_PREFIX:-"stdlib"}"
  local stdlib_function_regex="^${stdlib_library_prefix}\\..* ()"

  while IFS= read -r stdlib_fn_name; do
    stdlib_fn_definition="$(builtin declare -f "${stdlib_fn_name/" () "/}")"
    builtin eval "${stdlib_fn_definition//"${stdlib_library_prefix}."/"${stdlib_library_prefix}.testing.internal."}"
  done <<< "$(builtin declare -f | "${_STDLIB_BINARY_GREP}" -E "${stdlib_function_regex}")"
}

__testing.protected() {
  # $@: the stdlib library to call

  _STDLIB_BUILTIN_BOOLEAN=1 \
    "${1//"stdlib."/"stdlib.testing.internal."}" "${@:2}"
}
