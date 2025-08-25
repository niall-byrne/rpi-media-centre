#!/bin/bash

# stdlib binaries library

builtin set -eo pipefail

_STDLIB_BINARY_CAT="$(builtin command -v cat)"
_STDLIB_BINARY_CUT="$(builtin command -v cut)"
_STDLIB_BINARY_GREP="$(builtin command -v grep)"
_STDLIB_BINARY_HEAD="$(builtin command -v head)"
_STDLIB_BINARY_MKTEMP="$(builtin command -v mktemp)"
_STDLIB_BINARY_RM="$(builtin command -v rm)"
_STDLIB_BINARY_SED="$(builtin command -v sed)"
_STDLIB_BINARY_SORT="$(builtin command -v sort)"
_STDLIB_BINARY_TAIL="$(builtin command -v tail)"
_STDLIB_BINARY_TPUT="$(builtin command -v tput)"
_STDLIB_BINARY_TR="$(builtin command -v tr)"
