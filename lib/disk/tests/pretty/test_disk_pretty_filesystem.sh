#!/bin/bash

test_disk_pretty_filesystem_status__arg__correct_output() {
  TEST_EXPECTED="$(cat "${RPI_WORKING_DIRECTORY}"/lib/disk/tests/pretty/__fixtures__/filesystem_pretty.txt)"
  TEST_INPUT="$(cat "${RPI_WORKING_DIRECTORY}"/lib/disk/tests/pretty/__fixtures__/filesystem.txt)"

  _capture.output _disk_pretty_filesystem_status "${TEST_INPUT}"

  assert_output "${TEST_EXPECTED}"
}

test_disk_pretty_filesystem_status__pipe__correct_output() {
  TEST_EXPECTED="$(cat "${RPI_WORKING_DIRECTORY}"/lib/disk/tests/pretty/__fixtures__/filesystem_pretty.txt)"
  TEST_INPUT="$(cat "${RPI_WORKING_DIRECTORY}"/lib/disk/tests/pretty/__fixtures__/filesystem.txt)"

  TEST_OUTPUT="$(echo "${TEST_INPUT}" | _disk_pretty_filesystem_status)"

  assert_equals "${TEST_EXPECTED}" "${TEST_OUTPUT}"
}
