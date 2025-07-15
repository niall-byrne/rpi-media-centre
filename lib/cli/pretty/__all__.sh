#!/bin/bash

set -eo pipefail

# shellcheck source=lib/cli/pretty/colour.sh
source "${RPI_WORKING_DIRECTORY}/lib/cli/pretty/colour.sh"
# shellcheck source=lib/cli/pretty/justify.sh
source "${RPI_WORKING_DIRECTORY}/lib/cli/pretty/justify.sh"
# shellcheck source=lib/cli/pretty/pad.sh
source "${RPI_WORKING_DIRECTORY}/lib/cli/pretty/pad.sh"
# shellcheck source=lib/cli/pretty/pretty.sh
source "${RPI_WORKING_DIRECTORY}/lib/cli/pretty/pretty.sh"
# shellcheck source=lib/cli/pretty/string.sh
source "${RPI_WORKING_DIRECTORY}/lib/cli/pretty/string.sh"
# shellcheck source=lib/cli/pretty/strip.sh
source "${RPI_WORKING_DIRECTORY}/lib/cli/pretty/strip.sh"
# shellcheck source=lib/cli/pretty/wrap.sh
source "${RPI_WORKING_DIRECTORY}/lib/cli/pretty/wrap.sh"
