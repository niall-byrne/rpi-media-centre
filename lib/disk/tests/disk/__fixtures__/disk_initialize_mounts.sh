#!/bin/bash

_fixture_disk_initialize_mounts() {
  _mock.create stdlib.security.path.make.dir
  stdlib.security.path.make.dir.mock.clear
}

_fixture_disk_initialize_mounts__plex__calls() {
  echo "${RPI_PLEX_PATH_CONFIG} ${RPI_SVC_USERNAME} ${RPI_SVC_GROUPNAME} 700
${RPI_PLEX_PATH_TRANSCODE} ${RPI_SVC_USERNAME} ${RPI_SVC_GROUPNAME} 700
${RPI_ROOT}/shared/media ${RPI_SVC_USERNAME} ${RPI_SVC_GROUPNAME} 750"
}

_fixture_disk_initialize_mounts__samba__calls() {
  echo "${RPI_SAMBA_PATH_CONFIG} root root 700
${RPI_SAMBA_PATH_CONFIG}/cache ${RPI_SVC_USERNAME} ${RPI_SVC_GROUPNAME} 755
${RPI_SAMBA_PATH_CONFIG}/lib ${RPI_SVC_USERNAME} ${RPI_SVC_GROUPNAME} 755
${RPI_ROOT}/shared/media ${RPI_SVC_USERNAME} ${RPI_SVC_GROUPNAME} 750
${RPI_ROOT}/shared/transfer ${RPI_SVC_USERNAME} ${RPI_SVC_GROUPNAME} 750"
}

_fixture_disk_initialize_mounts__syncthing__calls() {
  echo "${RPI_SYNCTHING_PATH_CONFIG} ${RPI_SVC_USERNAME} ${RPI_SVC_GROUPNAME} 700
${RPI_ROOT}/shared/syncthing ${RPI_SVC_USERNAME} ${RPI_SVC_GROUPNAME} 750"
}
