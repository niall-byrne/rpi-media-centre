#!/bin/bash
# @file map.sh
# @brief A library for applying functions or formats to lines in a string.
# @description
#   This library provides functions to map over the lines in a string and apply a format string or a function to each line.

# stdlib string map library

set -eo pipefail

# @description Applies a printf format string to each line of a string.
# @arg $1 string A valid printf format string.
# @arg $2 string The input string to process.
# @env _DELIMITER The delimiter to split the string by. Defaults to newline.
# @exitcode ? Propagated from stdlib.fn.args.require.
# @stdout The formatted lines.
stdlib.string.map.format() {
  local delimiter="${_DELIMITER:-$'\n'}"
  local line=""
  local output=""

  stdlib.fn.args.require "2" "0" "${@}" || return "$?"

  if ! stdlib.string.query.has_substring "${delimiter}" "${2}"; then
    # shellcheck disable=SC2059
    printf "${1}" "${2}"
    echo
    return
  fi

  while IFS="${delimiter}" read -r -d "${delimiter}" line; do
    # shellcheck disable=SC2059
    output+="$(printf "${1}" "${line}")${delimiter}"
  done < <(echo -n "${2}${delimiter}")

  echo -e "${output%?}"
}

# @description Applies a function to each line of a string.
# @arg $1 string The name of the function to apply.
# @arg $2 string The input string to process.
# @env _DELIMITER The delimiter to split the string by. Defaults to newline.
# @exitcode 126 If the first argument is not a function.
# @exitcode ? Propagated from stdlib.fn.args.require.
# @stdout The output of the function for each line.
stdlib.string.map.fn() {
  local delimiter="${_DELIMITER:-$'\n'}"
  local line=""
  local output=""

  stdlib.fn.args.require "2" "0" "${@}" || return "$?"
  stdlib.fn.assert.is_fn "${1}" || return 126

  if ! stdlib.string.query.has_substring "${delimiter}" "${2}"; then
    "${1}" "${2}"
    return
  fi

  while IFS="${delimiter}" read -r -d "${delimiter}" line; do
    output+="$("${1}" "${line}")${delimiter}"
  done < <(echo -n "${2}${delimiter}")

  echo -e "${output%?}"
}
