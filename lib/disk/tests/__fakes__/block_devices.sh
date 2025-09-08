#!/bin/bash
# shellcheck disable=SC2034

# pictl testing disk fixtures

set -eo pipefail

_fake_block_devices() {
  sudo touch /dev/sda /dev/sdb /dev/sdc
}
