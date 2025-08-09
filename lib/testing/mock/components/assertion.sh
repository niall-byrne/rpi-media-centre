#!/bin/bash

# pictl testing mock assertion component

set -eo pipefail

export CONTENT

CONTENT="$(
  cat << EOF

${1}.mock.__count_matches() {
  # $1: a set of call args as a string

  local TEST_ACTUAL_ARG_STRING
  local TEST_ASSERTION_MATCHES=0
  local TEST_EXPECTED_ARG_STRING
  local TEST_MOCK_FILE_LINE

  TEST_EXPECTED_ARG_STRING="\$(printf "%q" "\${1}")"

  while IFS= read -r TEST_MOCK_FILE_LINE; do
    eval "\${TEST_MOCK_FILE_LINE}"
    printf -v TEST_ACTUAL_ARG_STRING "%q" "\${MOCK_ARGS[*]}"
    if [[ "\${TEST_EXPECTED_ARG_STRING}" == "\${TEST_ACTUAL_ARG_STRING}" ]]; then
      ((TEST_ASSERTION_MATCHES++))
    fi
  done < "\${__${2}_mock_calls_file}"

  echo "\${TEST_ASSERTION_MATCHES}"
}

${1}.mock.assert_any_call_is() {
  # $1: a set of call args as a string

  local TEST_ASSERTION_MATCHES

  TEST_ASSERTION_MATCHES="\$(${1}.mock.__count_matches "\${1}")"

  assert_not_equals "0" "\${TEST_ASSERTION_MATCHES}" "${1} was not called once with '\${1}'"
}

${1}.mock.assert_calls_are() {
  # $@: a set of call args as strings that should match

  local TEST_ACTUAL_ARG_STRING
  local TEST_ASSERTION_INDEX=0
  local TEST_ASSERTION_EXPECTED_MOCK_CALLS=("\${@}")
  local TEST_EXPECTED_ARG_STRING
  local TEST_MOCK_FILE_LINE=""

  while IFS= read -r TEST_MOCK_FILE_LINE; do
    eval "\${TEST_MOCK_FILE_LINE}"
    printf -v TEST_EXPECTED_ARG_STRING "%q" "\${TEST_ASSERTION_EXPECTED_MOCK_CALLS[TEST_ASSERTION_INDEX]}"
    printf -v TEST_ACTUAL_ARG_STRING "%q" "\${MOCK_ARGS[*]}"
    assert_equals \
      "\${TEST_EXPECTED_ARG_STRING}" \
      "\${TEST_ACTUAL_ARG_STRING}" \
      " at index \${TEST_ASSERTION_INDEX} the expected argument string was not found"
    ((TEST_ASSERTION_INDEX++))
  done < "\${__${2}_mock_calls_file}" || true

  if [[ "\${TEST_ASSERTION_INDEX}" == 0 ]]; then
    fail "${1} was not called!"
  fi
}

${1}.mock.assert_call_n_is() {
  # $1: the call count to assert
  # $2: a set of call args as a string

  local TEST_CALL_ARGS
  local TEST_CALL_COUNT

  TEST_CALL_COUNT="\$(${1}.mock.get.count)"

  if [[ "\${TEST_CALL_COUNT}" -lt "\${1}" ]]; then
    fail "${1} was called \${TEST_CALL_COUNT} time(s)"
  fi

  TEST_CALL_ARGS="\$("${1}.mock.get.call" "\${1}")"

  assert_equals "\${2}" "\${TEST_CALL_ARGS}" "${1} call \${1} was not called as expected"
}

${1}.mock.assert_called_once_with() {
  # $2: a set of call args as a string

  local TEST_ASSERTION_MATCHES
  local TEST_ACTUAL_CALL

  ${1}.mock.assert_count_is "1"

  TEST_ASSERTION_MATCHES="\$(${1}.mock.__count_matches "\${1}")"

  if [[ "\${TEST_ASSERTION_MATCHES}" != "1" ]]; then
    TEST_ACTUAL_CALL="\$(${1}.mock.get.call "1")"
    echo "Actual Call: [\${TEST_ACTUAL_CALL}]"
  fi

  assert_equals "1" "\${TEST_ASSERTION_MATCHES}" "${1} was not called once with '\${1}'"
}

${1}.mock.assert_count_is() {
  # $1: the call count to assert

  local TEST_CALL_COUNT

  TEST_CALL_COUNT="\$("${1}.mock.get.count")"

  assert_equals "\${1}" "\${TEST_CALL_COUNT}" "${1} was called \${TEST_CALL_COUNT} time(s)"
}

${1}.mock.assert_not_called() {
  local TEST_CALL_COUNT

  TEST_CALL_COUNT="\$(${1}.mock.get.count)"

  assert_equals "0" "\${TEST_CALL_COUNT}" "${1} was called \${TEST_CALL_COUNT} time(s)"
}
EOF
)"
