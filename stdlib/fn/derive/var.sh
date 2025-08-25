#!/bin/bash

# stdlib fn derive var library

builtin set -eo pipefail

stdlib.fn.derive.var() {
  # $1: the source function name
  # $2: (optional) the new target function name
  # $3: (optional) the argument index for the variable's existing value (defaults to the last value)

  local args_with_defaults=("$@")
  local derive_source_fn_name="${1}"
  local derive_target_fn_name
  local derive_argument_index="${3:-"-1"}"

  derive_target_fn_name="${2:-"${derive_source_fn_name}_var"}"

  args_with_defaults[1]="${derive_target_fn_name}"
  args_with_defaults[2]="${derive_argument_index}"

  stdlib.fn.args.require "3" "0" "${args_with_defaults[@]}" || return "$?"
  stdlib.fn.assert.is_fn "${1}" || return 126
  stdlib.fn.assert.is_valid_name "${derive_target_fn_name}" || return 126
  stdlib.string.assert.is_integer "${derive_argument_index}" || return 126
  stdlib.string.assert.not_equal "0" "${derive_argument_index}" || return 126

  builtin eval "$(
    # KCOV_EXCLUDE_BEGIN
    "${_STDLIB_BINARY_CAT}" << EOF

${derive_target_fn_name}() {
  # \${@} the args to pass to the source function, plus the variable name

  local fn_argument_index
  local fn_argument_index_variable_name="${derive_argument_index}"
  local fn_arguments=()
  local fn_variable_name=""

  stdlib.fn.args.require "1" "1000" "\${@}" || return "\$?"

  if [[ "${derive_argument_index}" -lt "0" ]]; then
    fn_argument_index_variable_name="\$(("\${#@}" + 1 + "${derive_argument_index}"))"
  fi

  for ((fn_argument_index=1; fn_argument_index <= "\${#@}"; fn_argument_index+=1)); do
    if (("\${fn_argument_index}" == "\${fn_argument_index_variable_name}")); then
      fn_variable_name="\${!fn_argument_index}"
      fn_arguments+=("\${!fn_variable_name}")
    else
      fn_arguments+=("\${!fn_argument_index}")
    fi
  done

  builtin printf -v "\${fn_variable_name}" "%s" "\$("${derive_source_fn_name}" "\${fn_arguments[@]}")"
}

EOF
  )"
  # KCOV_EXCLUDE_END
}
