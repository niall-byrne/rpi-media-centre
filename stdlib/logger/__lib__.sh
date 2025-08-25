#!/bin/bash

# stdlib logger library

builtin set -eo pipefail

# shellcheck source=stdlib/logger/logger.sh
source "${STDLIB_DIRECTORY}/logger/logger.sh"

stdlib.fn.derive.pipeable "stdlib.logger.error" "1"
stdlib.fn.derive.pipeable "stdlib.logger.warning" "1"
stdlib.fn.derive.pipeable "stdlib.logger.info" "1"
stdlib.fn.derive.pipeable "stdlib.logger.success" "1"
stdlib.fn.derive.pipeable "stdlib.logger.notice" "1"
