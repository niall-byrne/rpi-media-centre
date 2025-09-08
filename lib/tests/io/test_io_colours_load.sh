#!/bin/bash

setup() {
  _mock.create stdlib.setting.colour.enable
  _mock.create _io_theme_load
}

@parametrize_with_activated_colours() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_COLOUR_BOOLEAN;TEST_IO_COLOUR_FORCE_BOOLEAN" \
    "not_forced__configured_on_;1;0" \
    "forced______configured_on_;1;1" \
    "forced______configured_off;0;1"
}

# shellcheck disable=SC2034
test_io_colours_load__not_forced__configured_off__does_not_enable_stdlib_colours() {
  local RPI_COLOUR_BOOLEAN=0
  local RPI_IO_COLOUR_FORCE_BOOLEAN=0

  _io_colours_load

  stdlib.setting.colour.enable.mock.assert_not_called
}

# shellcheck disable=SC2034
test_io_colours_load__not_forced__configured_off__does_not_load_the_theme() {
  local RPI_COLOUR_BOOLEAN=0
  local RPI_IO_COLOUR_FORCE_BOOLEAN=0

  _io_colours_load

  _io_theme_load.mock.assert_not_called
}

# shellcheck disable=SC2034
test_io_colours_load__@vary__enables_stdlib_colours() {
  local RPI_COLOUR_BOOLEAN="${TEST_COLOUR_BOOLEAN}"
  local RPI_IO_COLOUR_FORCE_BOOLEAN="${TEST_IO_COLOUR_FORCE_BOOLEAN}"

  _io_colours_load

  stdlib.setting.colour.enable.mock.assert_called_once_with ""
}

@parametrize_with_activated_colours \
  test_io_colours_load__@vary__enables_stdlib_colours

# shellcheck disable=SC2034
test_io_colours_load__@vary__enable_successful_______loads_the_theme() {
  local RPI_COLOUR_BOOLEAN="${TEST_COLOUR_BOOLEAN}"
  local RPI_IO_COLOUR_FORCE_BOOLEAN="${TEST_IO_COLOUR_FORCE_BOOLEAN}"

  stdlib.setting.colour.enable.mock.set.rc 0

  _io_colours_load

  _io_theme_load.mock.assert_called_once_with ""
}

@parametrize_with_activated_colours \
  test_io_colours_load__@vary__enable_successful_______loads_the_theme

# shellcheck disable=SC2034
test_io_colours_load__@vary__enable_unsuccessful_____loads_the_theme() {
  local RPI_COLOUR_BOOLEAN="${TEST_COLOUR_BOOLEAN}"
  local RPI_IO_COLOUR_FORCE_BOOLEAN="${TEST_IO_COLOUR_FORCE_BOOLEAN}"

  stdlib.setting.colour.enable.mock.set.rc 1

  _io_colours_load

  _io_theme_load.mock.assert_not_called
}

@parametrize_with_activated_colours \
  test_io_colours_load__@vary__enable_unsuccessful_____loads_the_theme
