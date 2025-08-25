#!/bin/bash

# stdlib security getter library

builtin set -eo pipefail

stdlib.security.get.euid() {
  [[ "${#@}" == "0" ]] || return 127

  builtin echo "${EUID}"
}

stdlib.security.get.gid() {
  # $1: the group name to lookup the gid for

  [[ "${#@}" == "1" ]] || return 127
  [[ -n "${1}" ]] || return 126

  getent group "${1}" | "${_STDLIB_BINARY_CUT}" -d ":" -f 3 || return 126
}

stdlib.security.get.uid() {
  # $1: the username to lookup the uid for

  [[ "${#@}" == "1" ]] || return 127
  [[ -n "${1}" ]] || return 126

  id -u "${1}" || return 126
}

stdlib.security.get.unused_uid() {
  local current_id
  local existing_ids=()
  local existing_ids_index=0

  [[ "${#@}" == "0" ]] || return 127

  builtin read -d '' -ra existing_ids <<< \
    "$( # KCOV_EXCLUDE_BEGIN
      "${_STDLIB_BINARY_CAT}" /etc/group /etc/passwd |
        "${_STDLIB_BINARY_CUT}" -d ':' -f 3 |
        "${_STDLIB_BINARY_SORT}" -n |
        "${_STDLIB_BINARY_GREP}" "^....$\|^.....$"
    )" || builtin true # KCOV_EXCLUDE_END

  # based on 2.4 linux kernel limit
  for ((current_id = "1000"; current_id <= "65535"; current_id++)); do
    while ((existing_ids_index < "${#existing_ids[@]}")); do
      if ((current_id < "${existing_ids[existing_ids_index]}")); then
        builtin break
      fi
      if ((current_id == "${existing_ids[existing_ids_index]}")); then
        ((existing_ids_index = existing_ids_index + 1))
        builtin continue 2
      fi
      ((existing_ids_index = existing_ids_index + 1))
    done
    id "${current_id}" > /dev/null 2>&1 || {
      builtin echo "${current_id}"
      return 0
    }
  done

  return 1
}
