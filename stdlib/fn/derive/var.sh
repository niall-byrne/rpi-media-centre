#!/bin/bash

# stdlib fn derive var library

set -eo pipefail

stdlib.fn.derive.var() {
  # $1: the source function name
  # $2: (optional) the new target function name

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
