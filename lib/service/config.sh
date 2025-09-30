#!/bin/bash

# pictl service config library

set -eo pipefail

_service_config() {
  # $@: an array of service names that need configuration

  local service_name

  for service_name in "${@}"; do
    if _service_query_is_selected "${service_name}"; then
      "_config_service_${service_name}"
    fi
  done
}
