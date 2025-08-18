#!/bin/bash

# pictl docker query library

set -eo pipefail

_service_query_is_selected() {
  # $1: the service to check for selection

  stdlib.array.query.is_contains "${1}" RPI_SERVICES
}
