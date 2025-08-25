#!/bin/bash

# stdlib trap handler create library

builtin set -eo pipefail

stdlib.trap.create.clean_up_fn() {
  # $1: the clean up fn's name
  # $2: the array to use for tracking filesystem objects to cleanup
  # $3: (optional) a boolean indicating if recursive deletes should be done

  local rm_flags="-f"
  local recursive_deletes="${3:-0}"

  stdlib.fn.args.require "2" "1" "${@}" || return "$?"
  stdlib.array.assert.is_array "${2}" || return 126
  stdlib.string.assert.is_boolean "${recursive_deletes}" || return 126

  if (("${recursive_deletes}")); then
    rm_flags+="r"
  fi

  builtin eval "$(
    # KCOV_EXCLUDE_BEGIN
    "${_STDLIB_BINARY_CAT}" << EOF

${1}() {
  local clean_up_path

  [[ "\${#@}" -eq 0 ]] || return 127

  for clean_up_path in "\${${2}[@]}"; do
    if test -e "\${clean_up_path}"; then
      "${_STDLIB_BINARY_RM}" "${rm_flags}" "\${clean_up_path}"
    fi
  done
}

EOF
  )"
  # KCOV_EXCLUDE_END
}

stdlib.trap.create.handler() {
  # $1: the handler fn's name
  # $2: the array to store handler function names in

  stdlib.fn.args.require "2" "0" "${@}" || return "$?"
  stdlib.array.assert.is_array "${2}" || return 126

  builtin eval "$(
    # KCOV_EXCLUDE_BEGIN
    "${_STDLIB_BINARY_CAT}" << EOF

${1}() {
  local trap_handler_fn

  [[ "\${#@}" -eq 0 ]] || return 127

  for trap_handler_fn in "\${${2}[@]}"; do
    "\${trap_handler_fn}"
  done
}

${1}.register() {
  # $1: the function to register

  stdlib.fn.args.require "1" "0" "\${@}" || return "\$?"
  stdlib.fn.assert.is_fn "\${1}" || return 126

  ${2}+=("\${1}")
}

EOF
  )"
  # KCOV_EXCLUDE_END
}
