#!/bin/bash

# pictl disk manifest command mount library

set -eo pipefail

_disk_manifest_command_mount() {
  _event_script "event-disk-before-mounted.sh"
  _disk_manifest_command_all "_disk_unlock"
  _event_script "event-disk-after-mounted.sh"
}
