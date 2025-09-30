#!/bin/bash

# pictl configuration services syncthing library

set -eo pipefail

_configuration_service_syncthing() {
  _cli_log_warning "Configuring syncthing service credentials..."

  _configuration_service_syncthing_healthcheck

  _docker_compose_exec syncthing \
    syncthing \
    generate \
    --gui-password="${RPI_SYNCTHING_CREDENTIALS_PASSWORD}" \
    --gui-user="${RPI_SYNCTHING_CREDENTIALS_USERNAME}"
  _docker_compose_exec syncthing \
    chown "${RPI_SVC_UID}":"${RPI_SVC_GID}" /config/config.xml
  docker restart syncthing

  _configuration_service_syncthing_healthcheck

  _cli_log_success "Configuration complete!"
}

_configuration_service_syncthing_healthcheck() {
  while ! curl -fkLsS -m 2 127.0.0.1:8384/rest/noauth/health >> /dev/null 2>&1; do
    sleep 1
  done
}
