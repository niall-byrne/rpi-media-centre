#!/bin/bash

# pictl disk manifest command unmount library

set -eo pipefail

_disk_manifest_command_unmount() {
  _event_script "event-disk-before-unmounted.sh"
  _disk_manifest_command_all "_disk_lock"
  _event_script "event-disk-after-unmounted.sh"
}
