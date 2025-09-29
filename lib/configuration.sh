#!/bin/bash

# pictl configuration library

set -eo pipefail

RPI_CONFIGURATION_VALIDATORS_ALL_ARRAY=("account" "backup" "security")
RPI_CONFIGURATION_VALIDATORS_DISABLED_ARRAY=""

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

_configuration_pictl_validation() {
  # shellcheck disable=SC2034
  local configuration_disabled_validators=("${RPI_CONFIGURATION_VALIDATORS_DISABLED_ARRAY[@]}")
  local configuration_validator
  local configuration_validators=("${RPI_CONFIGURATION_VALIDATORS_ALL_ARRAY[@]}")

  for configuration_validator in "${configuration_validators[@]}"; do
    if ! stdlib.array.query.is_contains "${configuration_validator}" configuration_disabled_validators; then
      "_configuration_pictl_validation_${configuration_validator}"
    fi
  done
}

_configuration_pictl_validation_account() {
  _security_defaults_set
  _security_warning_single_user_mode
}

_configuration_pictl_validation_backup() {
  _backup_scheduler_validation
}

_configuration_pictl_validation_security() {
  _security_validate
}

_configuration_pihole() {
  _STDLIB_PASSWORD_BOOLEAN=1 \
    stdlib.io.stdin.prompt RPI_PIHOLE_CREDENTIALS_PASSWORD "Enter PiHole Password: "
}

_configuration_samba() {
  if stdlib.io.path.query.is_file /etc/rpi/samba.yml; then
    _cli_log_notice "-- loading /etc/rpi/samba.yml file ... --"
    stdlib.security.path.assert.is_secure /etc/rpi/samba.yml "root" "root" "600"
    cp -a /etc/rpi/samba.yml "${RPI_SAMBA_PATH_CONFIG}"/config.yml
  else
    cp -a ./services/samba/config.yml "${RPI_SAMBA_PATH_CONFIG}"/config.yml
  fi

  stdlib.io.stdin.prompt RPI_SAMBA_CREDENTIALS_USERNAME "Enter Samba Username: "
  _STDLIB_PASSWORD_BOOLEAN=1 \
    stdlib.io.stdin.prompt RPI_SAMBA_CREDENTIALS_PASSWORD "Enter Samba Password: "
  stdlib.io.stdin.prompt RPI_SAMBA_SUBNET "Enter Samba Network CIDR: "

  stdlib.security.path.make.dir "/var/run/rpi" "root" "root" "700"
  _docker_compose_filtered_env "SAMBA_" "/var/run/rpi/samba.env"
}

_configuration_syncthing() {
  _cli_log_warning "Configuring syncthing service credentials..."

  _configuration_syncthing_healthcheck

  _docker_compose_exec syncthing \
    syncthing \
    generate \
    --gui-password="${RPI_SYNCTHING_CREDENTIALS_PASSWORD}" \
    --gui-user="${RPI_SYNCTHING_CREDENTIALS_USERNAME}"
  _docker_compose_exec syncthing \
    chown "${RPI_SVC_UID}":"${RPI_SVC_GID}" /config/config.xml
  docker restart syncthing

  _configuration_syncthing_healthcheck

  _cli_log_success "Configuration complete!"
}

_configuration_syncthing_healthcheck() {
  while ! curl -fkLsS -m 2 127.0.0.1:8384/rest/noauth/health >> /dev/null 2>&1; do
    sleep 1
  done
}
