#!/bin/bash

# pictl service configuration library

set -eo pipefail

_service_configuration() {
  # $@: an array of service names that need configuration

  local service_name

  for service_name in "${@}"; do
    if _service_query_is_selected "${service_name}"; then
      "_configuration_service_${service_name}"
    fi
  done
}
