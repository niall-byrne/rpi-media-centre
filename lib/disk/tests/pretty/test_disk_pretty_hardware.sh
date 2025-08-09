#!/bin/bash

test_disk_pretty_hardware_status__arg__correct_output() {
  TEST_EXPECTED="$(cat "${RPI_WORKING_DIRECTORY}"/lib/disk/tests/pretty/__fixtures__/hardware_pretty.txt)"
  TEST_INPUT="$(cat "${RPI_WORKING_DIRECTORY}"/lib/disk/tests/pretty/__fixtures__/hardware.txt)"

  TEST_OUTPUT="$(_disk_pretty_hardware_status "${TEST_INPUT}")"

  assert_output "${TEST_EXPECTED}"
}

test_disk_pretty_hardware_status__pipe__correct_output() {
  TEST_EXPECTED="$(cat "${RPI_WORKING_DIRECTORY}"/lib/disk/tests/pretty/__fixtures__/hardware_pretty.txt)"
  TEST_INPUT="$(cat "${RPI_WORKING_DIRECTORY}"/lib/disk/tests/pretty/__fixtures__/hardware.txt)"

  TEST_OUTPUT="$(echo "${TEST_INPUT}" | _disk_pretty_hardware_status)"

  assert_equals "${TEST_EXPECTED}" "${TEST_OUTPUT}"
}
