#!/bin/bash

# pictl configuration library

set -eo pipefail

_configuration_pictl() {
  local RPI_CONFIGURATION_QUIET_LOAD=0

  _configuration_pictl_secure_load source .rpi/config
}

_configuration_pictl_check() {
  local RPI_CONFIGURATION_QUIET_LOAD=1

  _configuration_pictl_secure_load env -i bash -c "
  source .rpi/config &&
  declare -p | \
      grep '^declare -. RPI_' |
      sed 's/^declare -. //g' |
      sed 's/=.*//g' |
      sort
"
}

_configuration_pictl_help() {
  echo "The config file is a sourced BASH script that configures one or more of the following:"

  # Generate a summary from README.md
  grep '^| `RPI_' README.md |
    cut -d "|" -f2,3 |
    tr -d '`' |
    sed 's/  */ /g' |
    awk -F"|" '{ $1 = sprintf("%-40s", $1); print $1 $2}' |
    sed 's/the \[documentation\](\(.*\)) for/\1 for/g' |
    sort

  echo "Please see https://github.com/niall-byrne/rpi-media-centre for further details."
}

_configuration_pictl_secure_load() {
  # $@: the commands to execute after loading the configuration

  if [[ -f .rpi/config ]]; then
    if [[ "${RPI_CONFIGURATION_QUIET_LOAD}" -ne "1" ]]; then
      echo "-- loading .rpi/config file ... --"
    fi
    _filesystem_check_permissions .rpi/config "600"
    "$@"
  fi
}

_configuration_samba() {
  if [[ -f .rpi/samba.yml ]]; then
    echo "-- loading .rpi/samba.yml file ... --"
    _filesystem_check_permissions .rpi/samba.yml "600"
    cp -a .rpi/samba.yml "${RPI_SAMBA_PATH_CONFIG}"/config.yml
  else
    cp -a ./services/samba/config.yml "${RPI_SAMBA_PATH_CONFIG}"/config.yml
  fi

  _io_prompt "Enter Samba Username: " "RPI_SAMBA_CREDENTIALS_USERNAME"
  _io_prompt "Enter Samba Password: " "RPI_SAMBA_CREDENTIALS_PASSWORD" "password"
  _io_prompt "Enter Samba Network CIDR: " "RPI_SAMBA_SUBNET"
}

_configuration_syncthing() {
  _configuration_syncthing_setting RPI_SYNCTHING_CREDENTIALS_USERNAME gui user
  _configuration_syncthing_setting RPI_SYNCTHING_CREDENTIALS_PASSWORD gui password
}

_configuration_syncthing_setting() {
  # $1 the optional value to use
  # $@ the config key to set

  local VALUE="${1}"

  shift

  if [[ -n "${!VALUE}" ]]; then
    echo "Configuring syncthing '${*}' with environment variable '${VALUE}' ..."

    while ! curl -fkLsS -m 2 127.0.0.1:8384/rest/noauth/health >> /dev/null 2>&1; do
      sleep 1
    done

    _docker_compose_exec syncthing syncthing cli config "$@" set "${!VALUE}" >> /dev/null 2>&1
    sleep 1
  fi
}
