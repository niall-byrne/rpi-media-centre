#!/bin/bash

# pictl configuration services pihole library

set -eo pipefail

_configuration_service_pihole() {
  _STDLIB_PASSWORD_BOOLEAN=1 \
    stdlib.io.stdin.prompt RPI_PIHOLE_CREDENTIALS_PASSWORD "Enter PiHole Password: "
}
