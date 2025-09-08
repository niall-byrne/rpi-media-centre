#!/bin/bash

trap 'command_to_execute' SIGUSR1

_TEST_PATH_QUEUE_ROOT=""

_TEST_QUEUE1_NAME="test1"
_TEST_QUEUE1_PATH=""
_TEST_QUEUE2_NAME="test2"
_TEST_QUEUE2_PATH=""

_fixture_mock_backup_queues() {
  _TEST_PATH_QUEUE_ROOT="$(mktemp -d)"
  _TEST_QUEUE1_PATH="${_TEST_PATH_QUEUE_ROOT}/${_TEST_QUEUE1_NAME}"
  _TEST_QUEUE2_PATH="${_TEST_PATH_QUEUE_ROOT}/${_TEST_QUEUE2_NAME}"
  mkdir -p "${_TEST_QUEUE1_PATH}"
  mkdir -p "${_TEST_QUEUE2_PATH}"
}

_fixture_mock_backup_jobs() {
  # $1: the queue to use
  # $@: the suffixes to use for created jobs

  local JOB_INDEX
  local JOB_QUEUE="${1}"

  shift

  for JOB_INDEX in "$@"; do
    touch "${_TEST_PATH_QUEUE_ROOT}/${JOB_QUEUE}/job${JOB_INDEX}"
  done
}

_cleanup_mock_backup_queues() {
  if [[ -d "${_TEST_PATH_QUEUE_ROOT}" ]]; then
    rm -rf "${_TEST_PATH_QUEUE_ROOT}"
  fi
}

_cleanup_mock_backup_jobs() {
  local QUEUE_JOB
  local QUEUE_PATH
  local QUEUE_PATHS=("${_TEST_QUEUE1_PATH}" "${_TEST_QUEUE2_PATH}")

  for QUEUE_PATH in "${QUEUE_PATHS[@]}"; do
    for QUEUE_JOB in "${QUEUE_PATH}"/*; do
      if [[ -f "${QUEUE_JOB}" ]]; then
        rm "${QUEUE_JOB}"
      fi
    done
  done
}
