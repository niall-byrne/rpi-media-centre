#!/bin/bash

_fixture_disk_initialize_mounts() {
  _mock.create stdlib.security.path.make.dir
  stdlib.security.path.make.dir.mock.clear
}

_fixture_disk_initialize_mounts__pihole__calls() {
  echo "1(${RPI_PIHOLE_PATH_CONFIG}) 2(${RPI_SVC_USERNAME}) 3(${RPI_SVC_GROUPNAME}) 4(700)
1(${RPI_PIHOLE_PATH_DNSMASQ}) 2(${RPI_SVC_USERNAME}) 3(${RPI_SVC_GROUPNAME}) 4(700)"
}

_fixture_disk_initialize_mounts__plex__calls() {
  echo "1(${RPI_PLEX_PATH_CONFIG}) 2(${RPI_SVC_USERNAME}) 3(${RPI_SVC_GROUPNAME}) 4(700)
1(${RPI_PLEX_PATH_TRANSCODE}) 2(${RPI_SVC_USERNAME}) 3(${RPI_SVC_GROUPNAME}) 4(700)
1(${RPI_ROOT}/shared/media) 2(${RPI_SVC_USERNAME}) 3(${RPI_SVC_GROUPNAME}) 4(750)"
}

_fixture_disk_initialize_mounts__samba__calls() {
  echo "1(${RPI_SAMBA_PATH_CONFIG}) 2(root) 3(root) 4(700)
1(${RPI_SAMBA_PATH_CONFIG}/cache) 2(${RPI_SVC_USERNAME}) 3(${RPI_SVC_GROUPNAME}) 4(755)
1(${RPI_SAMBA_PATH_CONFIG}/lib) 2(${RPI_SVC_USERNAME}) 3(${RPI_SVC_GROUPNAME}) 4(755)
1(${RPI_ROOT}/shared/media) 2(${RPI_SVC_USERNAME}) 3(${RPI_SVC_GROUPNAME}) 4(750)
1(${RPI_ROOT}/shared/transfer) 2(${RPI_SVC_USERNAME}) 3(${RPI_SVC_GROUPNAME}) 4(750)"
}

_fixture_disk_initialize_mounts__syncthing__calls() {
  echo "1(${RPI_SYNCTHING_PATH_CONFIG}) 2(${RPI_SVC_USERNAME}) 3(${RPI_SVC_GROUPNAME}) 4(700)
1(${RPI_ROOT}/shared/syncthing) 2(${RPI_SVC_USERNAME}) 3(${RPI_SVC_GROUPNAME}) 4(750)"
}
