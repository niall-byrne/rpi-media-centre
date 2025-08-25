#!/bin/bash

# stdlib testing mock assertion component

builtin set -eo pipefail

export CONTENT

CONTENT="$(
  "${_STDLIB_BINARY_CAT}" << EOF
__${2}_mock_keywords=()
__${2}_mock_pipeable=0
__${2}_mock_rc=""
__${2}_mock_side_effects_boolean=0
__${2}_mock_stderr=""
__${2}_mock_stdout=""
EOF
)"
