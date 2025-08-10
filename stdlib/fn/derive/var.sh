#!/bin/bash
# @file var.sh
# @brief A library for creating functions that modify variables.
# @description
#   This library provides a function to create a new function that applies a given function to a variable
#   and stores the result back in the same variable.

# stdlib fn derive var library

set -eo pipefail

# @description Creates a new function that applies a source function to a variable.
# The new function is named by appending '_var' to the source function's name, or by the name provided in the second argument.
# The last argument to the new function is the name of the variable to be modified.
# @arg $1 string The name of the source function.
# @arg $2 string (optional) The name of the new function to create.
# @exitcode 126 If the source function does not exist, or if the argument is null.
# @exitcode 127 If an incorrect number of arguments have been passed.
stdlib.fn.derive.var() {
  local derive_source_fn_name="${1}"
  local derive_target_fn_name

  stdlib.fn.args.require "1" "1" "${@}" || return "$?"
  stdlib.fn.assert.is_fn "${1}" || return 126

  derive_target_fn_name="${2:-"${derive_source_fn_name}_var"}"

  #:nocov:
  # bashcov doesn't report this section correctly
  eval "$(
    cat << EOF

${derive_target_fn_name}() {
  # \${@: -2} the args to pass to the source function
  # \${@: -1} the variable name to apply the function to

  local fn_variable_name="\${@: -1}"

  stdlib.fn.args.require "1" "1000" "\${@}" || return "$?"

  if [[ "\${#@}" -eq "1" ]]; then
    printf -v "\${fn_variable_name}" "%s" "\$("${derive_source_fn_name}" "\${!fn_variable_name}")"
  else
    printf -v "\${fn_variable_name}" "%s" "\$("${derive_source_fn_name}" "\${@:1:\${#@}-1}" "\${!fn_variable_name}")"
  fi
}

EOF
  )"
  #:nocov:
}
