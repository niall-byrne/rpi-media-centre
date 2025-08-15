#!/bin/bash

# stdlib testing mock controller component

set -eo pipefail

export CONTENT

CONTENT="$(
  cat << EOF
${1}.mock.__controller() {
  # $1: the mock component to execute
  # $@: additional arguments to pass

  local _mock_object_pipe_input_line
  local _mock_object_side_effect
  local _mock_object_side_effects=()

  case "\${1}" in
    call)
      declare -p _mock_object_args >> "\${__${2}_mock_calls_file}"
      __MOCK_SEQUENCE+=("${1}")
      ;;
    pipeable)
      while IFS= read -r _mock_object_pipe_input_line; do
        _mock_object_pipe_input+="\${_mock_object_pipe_input_line}"
      done
      ;;
    side_effects)
      if [[ "\${__${2}_mock_side_effects_boolean}" == "1" ]]; then
        eval "\$(<"\${__${2}_mock_side_effects_file}")"
        if [[ "\${#_mock_object_side_effects[@]}" -gt 0 ]]; then
          _mock_object_side_effect="\${_mock_object_side_effects[0]}"
          _mock_object_side_effects=("\${_mock_object_side_effects[@]:1}")
          declare -p _mock_object_side_effects > "\${__${2}_mock_side_effects_file}"
          eval "\${_mock_object_side_effect}"
        fi
      fi
      ;;
    stderr)
      if [[ -n "\${__${2}_mock_stderr}" ]]; then
        echo "\${__${2}_mock_stderr}" >&2
      fi
      ;;
    stdout)
      if [[ -n "\${__${2}_mock_stdout}" ]]; then
        echo "\${__${2}_mock_stdout}"
      fi
      ;;
    subcommand)
      if declare -F __${1}_mock_subcommand > /dev/null 2>&1; then
        __${1}_mock_subcommand "\${@:2}"
      fi
      ;;
    update_rc)
      # if passed a valid return code, and we're not set to 0 then update to the newest code
      if [[ -n "\${2}" ]] && [[ "\${_mock_object_rc}" == "0" ]]; then
        _mock_object_rc="\${2}"
      fi
      ;;
  esac
}
EOF
)"
