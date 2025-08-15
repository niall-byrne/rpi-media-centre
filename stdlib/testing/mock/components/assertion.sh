#!/bin/bash

# stdlib testing mock assertion component

set -eo pipefail

export CONTENT

CONTENT="$(
  cat << EOF

${1}.mock.__count_matches() {
  # $1: a set of call args as a string

  local _mock_object_arg_string_actual
  local _mock_object_arg_string_expected
  local _mock_object_call_definition
  local _mock_object_match_count=0

  _mock_object_arg_string_expected="\$(printf "%q" "\${1}")"

  while IFS= read -r _mock_object_call_definition; do
    eval "\${_mock_object_call_definition}"
    printf -v _mock_object_arg_string_actual "%q" "\${_mock_object_args[*]}"
    if [[ "\${_mock_object_arg_string_expected}" == "\${_mock_object_arg_string_actual}" ]]; then
      ((_mock_object_match_count++))
    fi
  done < "\${__${2}_mock_calls_file}"

  echo "\${_mock_object_match_count}"
}

${1}.mock.assert_any_call_is() {
  # $1: a set of call args as a string

  local _mock_object_match_count

  _mock_object_match_count="\$(${1}.mock.__count_matches "\${1}")"

  assert_not_equals "0" "\${_mock_object_match_count}" "${1} was not called once with '\${1}'"
}

${1}.mock.assert_calls_are() {
  # $@: a set of call args as strings that should match

  local _mock_object_arg_string_actual
  local _mock_object_arg_string_expected
  local _mock_object_call_definition=""
  local _mock_object_call_index=0
  local _mock_object_expected_mock_calls=("\${@}")

  while IFS= read -r _mock_object_call_definition; do
    eval "\${_mock_object_call_definition}"
    printf -v _mock_object_arg_string_expected "%q" "\${_mock_object_expected_mock_calls[_mock_object_call_index]}"
    printf -v _mock_object_arg_string_actual "%q" "\${_mock_object_args[*]}"
    assert_equals \
      "\${_mock_object_arg_string_expected}" \
      "\${_mock_object_arg_string_actual}" \
      " at index \${_mock_object_call_index} the expected argument string was not found"
    ((_mock_object_call_index++))
  done < "\${__${2}_mock_calls_file}" || true

  if [[ "\${_mock_object_call_index}" == 0 ]]; then
    fail "${1} was not called!"
  fi
}

${1}.mock.assert_call_n_is() {
  # $1: the call count to assert
  # $2: a set of call args as a string

  local _mock_object_arg_string_actual
  local _mock_object_call_count

  _mock_object_call_count="\$(${1}.mock.get.count)"

  if [[ "\${_mock_object_call_count}" -lt "\${1}" ]]; then
    fail "${1} was called \${_mock_object_call_count} time(s)"
  fi

  _mock_object_arg_string_actual="\$("${1}.mock.get.call" "\${1}")"

  assert_equals "\${2}" "\${_mock_object_arg_string_actual}" "${1} call \${1} was not called as expected"
}

${1}.mock.assert_called_once_with() {
  # $2: a set of call args as a string

  local _mock_object_arg_string_actual
  local _mock_object_match_count

  ${1}.mock.assert_count_is "1"

  _mock_object_match_count="\$(${1}.mock.__count_matches "\${1}")"

  if [[ "\${_mock_object_match_count}" != "1" ]]; then
    _mock_object_arg_string_actual="\$(${1}.mock.get.call "1")"
    echo "Actual Call: [\${_mock_object_arg_string_actual}]"
  fi

  assert_equals "1" "\${_mock_object_match_count}" "${1} was not called once with '\${1}'"
}

${1}.mock.assert_count_is() {
  # $1: the call count to assert

  local _mock_object_call_count

  _mock_object_call_count="\$("${1}.mock.get.count")"

  assert_equals "\${1}" "\${_mock_object_call_count}" "${1} was called \${_mock_object_call_count} time(s)"
}

${1}.mock.assert_not_called() {
  local _mock_object_call_count

  _mock_object_call_count="\$(${1}.mock.get.count)"

  assert_equals "0" "\${_mock_object_call_count}" "${1} was called \${_mock_object_call_count} time(s)"
}
EOF
)"
