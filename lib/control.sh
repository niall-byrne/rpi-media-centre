#!/bin/bash

# pictl control library

set -eo pipefail

_control_lock() {
  # $1: the lock file to use
  # $2: the amount of time to wait for an unlock

  local RPI_CONTROL_WAIT_TIME=0

  while [[ -e "/var/lock/${1}" ]]; do
    sleep 1
    RPI_CONTROL_WAIT_TIME="$((RPI_CONTROL_WAIT_TIME + 1))"

    if (("${RPI_CONTROL_WAIT_TIME}" >= "${2}")); then
      echo "CONTROL: another process has reported it is executing this command."
      echo "If you believe it to be safe you may execute: sudo rm '/var/lock/${1}'"
      return 127
    fi
  done

  echo "${BASHPID}" |
    sudo tee "/var/lock/${1}" > /dev/null

  # shellcheck disable=SC2064
  trap "sudo rm '/var/lock/${1}'" EXIT
}

_control_retries() {
  # $1: the number of times to retry the command
  # $@: the command itself and arguments

  local RPI_CONTROL_RETRY_BACKOFF="1"
  local RPI_CONTROL_RETRY_RETRIES="0"
  local RPI_CONTROL_RETRY_MAXIMUM="${1}"

  shift

  while ((RPI_CONTROL_RETRY_RETRIES < RPI_CONTROL_RETRY_MAXIMUM)); do
    if "$@"; then
      return 0
    else
      echo "CONTROL: An error occurred, retrying in ${RPI_CONTROL_RETRY_BACKOFF} second(s)..." >&2
      sleep "${RPI_CONTROL_RETRY_BACKOFF}"
      RPI_CONTROL_RETRY_RETRIES=$((RPI_CONTROL_RETRY_RETRIES + 1))
    fi
  done

  echo "CONTROL: This command has failed, despite retries."

  return 127
}

_control_pushd() {
  # $1: the target directory
  # $@: the command itself and arguments

  local RPI_CONTROL_ERROR_CODE
  local RPI_CONTROL_TARGET_DIRECTORY="${1}"

  shift

  pushd "${RPI_CONTROL_TARGET_DIRECTORY}" > /dev/null
  "$@"
  RPI_CONTROL_ERROR_CODE="$?"
  popd > /dev/null

  return "${RPI_CONTROL_ERROR_CODE}"
}
