#!/bin/bash
# @file query.sh
# @brief A library for querying the filesystem.
# @description
#   This library provides functions to query the filesystem,
#   such as checking if a path exists, if it's a file or a folder.

# stdlib io filesystem query library

set -eo pipefail

# @description Checks if a path exists on the filesystem.
# @arg $1 string The path to check.
# @exitcode 0 If the path exists.
# @exitcode 1 If the path does not exist.
# @exitcode 126 If the argument is an empty string.
# @exitcode 127 If an incorrect number of arguments have been passed.
stdlib.io.filesystem.query.exists() {
  [[ "${#@}" == "1" ]] || return 127
  [[ -n "${1}" ]] || return 126
  test -e "${1}" || return 1
}

# @description Checks if a path is a folder.
# @arg $1 string The path to check.
# @exitcode 0 If the path is a folder.
# @exitcode 1 If the path is not a folder.
# @exitcode 126 If the argument is an empty string.
# @exitcode 127 If an incorrect number of arguments have been passed.
stdlib.io.filesystem.query.is_folder() {
  [[ "${#@}" == "1" ]] || return 127
  [[ -n "${1}" ]] || return 126
  test -d "${1}" || return 1
}

# @description Checks if a path is a file.
# @arg $1 string The path to check.
# @exitcode 0 If the path is a file.
# @exitcode 1 If the path is not a file.
# @exitcode 126 If the argument is an empty string.
# @exitcode 127 If an incorrect number of arguments have been passed.
stdlib.io.filesystem.query.is_file() {
  [[ "${#@}" == "1" ]] || return 127
  [[ -n "${1}" ]] || return 126
  test -f "${1}" || return 1
}
