#!/bin/bash

# pictl configuration pictl library

set -eo pipefail

_configuration_pictl() {
  local RPI_CONFIGURATION_QUIET_LOAD=0

  _configuration_pictl_secure_load source /etc/rpi/config
}

_configuration_pictl_check() {
  local RPI_CONFIGURATION_QUIET_LOAD=1

  # KCOV_EXCLUDE_BEGIN
  _configuration_pictl_secure_load env -i bash -c "
  source /etc/rpi/config &&
  declare -p | \
      grep '^declare -. RPI_' |
      sed 's/^declare -. //g' |
      sed 's/=.*//g' |
      sort
"
  # KCOV_EXCLUDE_END
}

_configuration_pictl_debug() {
  local RPI_CONFIGURATION_QUIET_LOAD=1

  _cli_pretty_title "-- rpi-media-centre running configuration --"
  _cli_pretty_highlight "** credentials have been removed **"
  declare -p |
    grep -E '^declare -.x? RPI_' |
    grep -v "CREDENTIALS" |
    sed 's/^declare \(-.\|-.x\) //g' |
    sort |
    _cli_pretty_env_var_pipe
}

_configuration_pictl_help() {
  _cli_pretty_highlight "The config file is a sourced BASH script that configures one or more of the following:"

  # Generate a summary from README.md
  grep '^| `RPI_' README.md |
    cut -d "|" -f2,3 |
    sort |
    _cli_pretty_markdown_link_pipe |
    _cli_pretty_columns_pipe

  echo "Please see ${RPI_PROJECT_REPOSITORY} for further details."
}

_configuration_pictl_secure_load() {
  # $@: the commands to execute after loading the configuration

  if stdlib.io.path.query.is_file /etc/rpi/config; then
    if [[ "${RPI_CONFIGURATION_QUIET_LOAD}" -ne "1" ]]; then
      _cli_log_notice "-- loading /etc/rpi/config file ... --"
    fi
    stdlib.security.path.assert.is_secure /etc/rpi/config "root" "root" "600"
    "$@"
  fi
}
