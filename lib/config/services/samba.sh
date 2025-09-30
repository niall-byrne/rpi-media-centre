#!/bin/bash

# pictl config services samba library

set -eo pipefail

_config_service_samba() {
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
