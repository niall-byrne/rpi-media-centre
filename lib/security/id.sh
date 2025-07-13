#!/bin/bash

# pictl security id library

set -eo pipefail

_security_id_get_gid() {
  # $1: the group name to lookup the gid for

  getent group "${1}" | cut -d ":" -f 3
}

_security_id_get_uid() {
  # $1: the username to lookup the uid for

  id -u "${1}"
}

_security_id_get_uid_next_available() {
  cat /etc/group /etc/passwd | cut -d ':' -f 3 | grep "^1...$" | sort -n | tail -n 1 | awk '{ print $1+1 }'
}
