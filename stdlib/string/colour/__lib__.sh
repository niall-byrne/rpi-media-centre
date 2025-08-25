#!/bin/bash

# stdlib string colour library

builtin set -eo pipefail

# shellcheck source=stdlib/string/colour/colour.sh
source "${STDLIB_DIRECTORY}/string/colour/colour.sh"
# shellcheck source=stdlib/string/colour/substring.sh
source "${STDLIB_DIRECTORY}/string/colour/substring.sh"

stdlib.fn.derive.pipeable "stdlib.string.colour_n" "2"
stdlib.fn.derive.var "stdlib.string.colour_n" "stdlib.string.colour_var"
stdlib.fn.derive.pipeable "stdlib.string.colour" "2"
stdlib.fn.derive.pipeable "stdlib.string.colour.substring" "3"
stdlib.fn.derive.var "stdlib.string.colour.substring"
stdlib.fn.derive.pipeable "stdlib.string.colour.substrings" "3"
stdlib.fn.derive.var "stdlib.string.colour.substrings"
