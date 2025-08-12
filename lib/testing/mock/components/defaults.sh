#!/bin/bash

# pictl testing mock assertion component

set -eo pipefail

export CONTENT

CONTENT="$(
  cat << EOF
__${2}_mock_pipeable=0
__${2}_mock_rc=""
__${2}_mock_side_effects_boolean=0
__${2}_mock_stderr=""
__${2}_mock_stdout=""
EOF
)"
