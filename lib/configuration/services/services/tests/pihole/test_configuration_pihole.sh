#!/bin/bash

setup() {
  _mock.create stdlib.io.stdin.prompt

  stdlib.io.stdin.prompt.mock.set.keywords "_STDLIB_PASSWORD_BOOLEAN"
}

test_configuration_service_pihole__prompts_for_password() {
  _configuration_service_pihole

  stdlib.io.stdin.prompt.mock.assert_called_once_with \
    "1(RPI_PIHOLE_CREDENTIALS_PASSWORD) 2(Enter PiHole Password: ) _STDLIB_PASSWORD_BOOLEAN(1)"
}
