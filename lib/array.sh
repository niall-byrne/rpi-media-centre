#!/bin/bash

# pictl array library

set -eo pipefail

_array_append_string_n() {
  # $1: the array name
  # $2: the char to repeat
  # $3: the count of char

  local ARRAY_INDEX

  for ((ARRAY_INDEX = 0; ARRAY_INDEX < "${3}"; ARRAY_INDEX++)); do
    printf -v "${1}[${ARRAY_INDEX}]" "%s" "${2}"
  done
}

_array_last() {
  # $1: the array name

  local INDIRECT_REFERENCE
  local INDIRECT_ARRAY=()
  local INDIRECT_ARRAY_LAST_ELEMENT_INDEX

  INDIRECT_REFERENCE="${1}[@]"
  INDIRECT_ARRAY=("${!INDIRECT_REFERENCE}")

  if [[ -z "${INDIRECT_ARRAY[*]}" ]] ||
    [[ "${#INDIRECT_ARRAY[@]}" == 0 ]]; then
    echo "_array_last: there are no elements left in the array!"
  fi

  _ARRAY_BUFFER="${INDIRECT_ARRAY[INDIRECT_ARRAY_LAST_ELEMENT_INDEX]}"
}

_array_length() {
  # $1: the array name

  local INDIRECT_REFERENCE
  local INDIRECT_ARRAY=()
  local INDIRECT_ARRAY_LAST_ELEMENT_INDEX

  INDIRECT_REFERENCE="${1}[@]"
  INDIRECT_ARRAY=("${!INDIRECT_REFERENCE}")

  echo "${#INDIRECT_ARRAY[@]}"
}

_array_longest_member() {
  # $1: the array name

  local INDIRECT_REFERENCE
  local INDIRECT_ARRAY=()
  local INDIRECT_ARRAY_LAST_ELEMENT_INDEX
  local INDIRECT_ARRAY_ELEMENT
  local ARRAY_LONGEST_MEMBER_LENGTH=0

  INDIRECT_REFERENCE="${1}[@]"
  INDIRECT_ARRAY=("${!INDIRECT_REFERENCE}")

  for INDIRECT_ARRAY_ELEMENT in "${INDIRECT_ARRAY[@]}"; do
    if [[ "${#INDIRECT_ARRAY_ELEMENT}" -gt "${ARRAY_LONGEST_MEMBER_LENGTH}" ]]; then
      ARRAY_LONGEST_MEMBER_LENGTH="${#INDIRECT_ARRAY_ELEMENT}"
    fi
  done

  echo "${ARRAY_LONGEST_MEMBER_LENGTH}"
}

_array_from_file() {
  # $1: the array name
  # $2: the seperator
  # $3: the source file

  if [[ ! -f "${3}" ]]; then
    echo "_array_from_file: the specified file '${3}' could not be found!"
    return 127
  fi

  IFS="${2}" read -ra "${1}" < "${3}"
}

_array_from_string() {
  # $1: the array name
  # $2: the seperator
  # $3: the source string

  IFS="${2}" read -ra "${1}" <<< "${3}"
}

_array_is_array() {
  # $1: the array name

  if [[ -z "${1}" ]]; then
    echo "_array_is_array: the specified variable '${1}' is not set!"
    return 1
  fi

  if declare -p "${1}" 2> /dev/null | grep -q 'declare -a'; then
    return 0
  else
    return 1
  fi
}

_array_pop() {
  # $1: the array name
  # $2: the buffer name

  local INDIRECT_REASSIGNMENT
  local INDIRECT_BUFFER_ASSIGNMENT
  local INDIRECT_REFERENCE
  local INDIRECT_ARRAY=()
  local INDIRECT_ARRAY_LAST_ELEMENT_INDEX

  _array_last "${1}"

  INDIRECT_REFERENCE="${1}[@]"
  INDIRECT_ARRAY=("${!INDIRECT_REFERENCE}")

  if [[ -z "${INDIRECT_ARRAY[*]}" ]] ||
    [[ "${#INDIRECT_ARRAY[@]}" == 0 ]]; then
    echo "_array_pop: there are no elements left in the array!"
  fi

  INDIRECT_ARRAY_LAST_ELEMENT_INDEX="$((${#INDIRECT_ARRAY[@]} - 1))"

  printf -v "INDIRECT_BUFFER_ASSIGNMENT" "%s" "${INDIRECT_ARRAY[INDIRECT_ARRAY_LAST_ELEMENT_INDEX]}"
  echo "${2}='${INDIRECT_BUFFER_ASSIGNMENT}'"

  if [[ "${INDIRECT_ARRAY_LAST_ELEMENT_INDEX}" == 0 ]]; then
    INDIRECT_ARRAY=()
    echo "${1}=()"
  else
    INDIRECT_ARRAY=("${INDIRECT_ARRAY[@]:0:"${INDIRECT_ARRAY_LAST_ELEMENT_INDEX}"}")
    printf -v "INDIRECT_REASSIGNMENT" "%q " "${INDIRECT_ARRAY[@]}"
    echo "${1}=(${INDIRECT_REASSIGNMENT})"
  fi
}
