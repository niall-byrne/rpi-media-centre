#!/bin/bash

_fixture_generate_ls_output() {
  # $1: number of files to generate
  # $2: tarball folder
  # $3: job name

  local index

  for index in $(seq 1 "${1}"); do
    echo "${2}/${3}_2023-10-27_10-00-0${index}.tar"
  done
}
