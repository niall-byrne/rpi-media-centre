#!/bin/bash

# stdlib trap handler create library

builtin set -Eeo pipefail

STDLIB_TRACEBACK_DISABLE_BOOLEAN="${STDLIB_TRACEBACK_DISABLE_BOOLEAN:-0}"

# shellcheck disable=SC2034
STDLIB_HANDLER_ERR=()
# shellcheck disable=SC2034
STDLIB_HANDLER_EXIT=()
# shellcheck disable=SC2034
STDLIB_CLEANUP_FN=()

stdlib.trap.create.handler "stdlib.trap.handler.err.fn" STDLIB_HANDLER_ERR
stdlib.trap.create.handler "stdlib.trap.handler.exit.fn" STDLIB_HANDLER_EXIT
stdlib.trap.create.clean_up_fn "stdlib.trap.fn.clean_up_on_exit" STDLIB_CLEANUP_FN

stdlib.trap.handler.exit.fn.register stdlib.trap.fn.clean_up_on_exit

trap stdlib.trap.handler.err.fn ERR
trap stdlib.trap.handler.exit.fn EXIT

if [[ "${STDLIB_TRACEBACK_DISABLE_BOOLEAN}" -eq "0" ]]; then
  stdlib.trap.handler.err.fn.register stdlib.logger.traceback
fi
