#!/bin/bash
# @file getter.sh
# @brief A library for getting security-related information.
# @description
#   This library provides functions to get security-related information,
#   such as user and group IDs.

# stdlib security getter library

set -eo pipefail

# @description Gets the effective user ID of the current user.
# @exitcode 127 If an incorrect number of arguments have been passed.
# @stdout The effective user ID.
stdlib.security.get.euid() {
  [[ "${#@}" == "0" ]] || return 127

  echo "${EUID}"
}

# @description Gets the group ID for a given group name.
# @arg $1 string The group name to look up.
# @exitcode 126 If the group name is empty or not found.
# @exitcode 127 If an incorrect number of arguments have been passed.
# @stdout The group ID.
stdlib.security.get.gid() {
  [[ "${#@}" == "1" ]] || return 127
  [[ -n "${1}" ]] || return 126

  getent group "${1}" | cut -d ":" -f 3 || return 126
}

# @description Gets the user ID for a given username.
# @arg $1 string The username to look up.
# @exitcode 126 If the username is empty or not found.
# @exitcode 127 If an incorrect number of arguments have been passed.
# @stdout The user ID.
stdlib.security.get.uid() {
  [[ "${#@}" == "1" ]] || return 127
  [[ -n "${1}" ]] || return 126

  id -u "${1}" || return 126
}

# @description Finds an unused user ID in the system.
# It searches for an unused UID between 1000 and 65535.
# @exitcode 0 If an unused UID is found.
# @exitcode 1 If no unused UID is found in the range.
# @exitcode 127 If an incorrect number of arguments have been passed.
# @stdout The first unused user ID found.
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
