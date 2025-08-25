#!/bin/bash

# stdlib testing mock internal sanitize component

builtin set -eo pipefail

__mock.create_sanitized_fn_name() {
  # $1: the function name to sanitize

  local _fn_name_sanitized
  local _fn_name_original="${1}"

  _fn_name_sanitized="${_fn_name_original//@/____at_sign____}"
  _fn_name_sanitized="${_fn_name_sanitized//-/____dash____}"
  _fn_name_sanitized="${_fn_name_sanitized//./____dot____}"

  builtin echo "${_fn_name_sanitized}_sanitized"
}
