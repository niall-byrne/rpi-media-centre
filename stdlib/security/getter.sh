#!/bin/bash

# stdlib security getter library

set -eo pipefail

stdlib.security.get.euid() {
  [[ "${#@}" == "0" ]] || return 127

  echo "${EUID}"
}

stdlib.security.get.gid() {
  # $1: the group name to lookup the gid for

  [[ "${#@}" == "1" ]] || return 127
  [[ -n "${1}" ]] || return 126

  getent group "${1}" | cut -d ":" -f 3 || return 126
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

  read -d '' -ra existing_ids <<< "$(
    #:nocov:
    # bashcov doesn't report this section correctly
    cat /etc/group /etc/passwd |
      cut -d ':' -f 3 |
      sort -n |
      grep "^....$\|^.....$"
  )"
  #:nocov:

  # based on 2.4 linux kernel limit
  for ((current_id = "1000"; current_id <= "65535"; current_id++)); do
    while ((existing_ids_index < "${#existing_ids[@]}")); do
      if ((current_id < "${existing_ids[existing_ids_index]}")); then
        break
      fi
      #:nocov:
      # bashcov doesn't report this section correctly
      ((existing_ids_index++))
      #:nocov:
    done
    id "${current_id}" || {
      echo "${current_id}"
      return 0
    }
  done

  return 1
}
