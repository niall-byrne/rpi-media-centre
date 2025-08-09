#!/bin/bash

# pictl configuration library

set -eo pipefail

_configuration_pictl() {
  local RPI_CONFIGURATION_QUIET_LOAD=0

  _configuration_pictl_secure_load source /etc/rpi/config
}

_configuration_pictl_check() {
  local RPI_CONFIGURATION_QUIET_LOAD=1

  _configuration_pictl_secure_load env -i bash -c "
  source /etc/rpi/config &&
  declare -p | \
      grep '^declare -. RPI_' |
      sed 's/^declare -. //g' |
      sed 's/=.*//g' |
      sort
"
}

_configuration_pictl_debug() {
  local RPI_CONFIGURATION_QUIET_LOAD=1

  _cli_pretty_title "-- rpi-media-centre running configuration --"
  _cli_pretty_highlight "** credentials have been removed **"
  declare -p |
    grep '^declare -. RPI_' |
    grep -v "CREDENTIALS" |
    grep -v "COLOUR" |
    sed 's/^declare -. //g' |
    sort |
    _cli_pretty_env_var
}

_configuration_pictl_help() {
  _cli_pretty_highlight "The config file is a sourced BASH script that configures one or more of the following:"

  # Generate a summary from README.md
  grep '^| `RPI_' README.md |
    cut -d "|" -f2,3 |
    sort |
    _cli_pretty_markdown_link |
    _cli_pretty_columns

  echo "Please see ${RPI_PROJECT_REPOSITORY} for further details."
}

_configuration_pictl_secure_load() {
  # $@: the commands to execute after loading the configuration

  if [[ -f /etc/rpi/config ]]; then
    if [[ "${RPI_CONFIGURATION_QUIET_LOAD}" -ne "1" ]]; then
      _cli_log_notice "-- loading /etc/rpi/config file ... --"
    fi
    _security_path_check /etc/rpi/config "root" "root" "600"
    "$@"
  fi
}

_configuration_pihole() {
  _io_prompt "Enter PiHole Password: " "RPI_PIHOLE_CREDENTIALS_PASSWORD" "password"
}

_configuration_samba() {
  if [[ -f /etc/rpi/samba.yml ]]; then
    _cli_log_notice "-- loading /etc/rpi/samba.yml file ... --"
    _security_path_check /etc/rpi/samba.yml "root" "root" "600"
    cp -a /etc/rpi/samba.yml "${RPI_SAMBA_PATH_CONFIG}"/config.yml
  else
    cp -a ./services/samba/config.yml "${RPI_SAMBA_PATH_CONFIG}"/config.yml
  fi

  _io_prompt "Enter Samba Username: " "RPI_SAMBA_CREDENTIALS_USERNAME"
  _io_prompt "Enter Samba Password: " "RPI_SAMBA_CREDENTIALS_PASSWORD" "password"
  _io_prompt "Enter Samba Network CIDR: " "RPI_SAMBA_SUBNET"

  _security_path_mkdir "/var/run/rpi" "root" "root" "700"
  _docker_create_filtered_env "SAMBA_" "/var/run/rpi/samba.env"
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
    _cli_log_warning "Configuring syncthing '${*}' with environment variable '${VALUE}' ..."

    while ! curl -fkLsS -m 2 127.0.0.1:8384/rest/noauth/health >> /dev/null 2>&1; do
      sleep 1
    done

    _docker_compose_exec syncthing syncthing cli config "$@" set "${!VALUE}" >> /dev/null 2>&1
    sleep 1
  fi
}
