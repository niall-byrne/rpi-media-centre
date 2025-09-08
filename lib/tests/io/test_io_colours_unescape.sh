#!/bin/bash

test_io_colours_unescape__unloads_colours() {
  _mock.create _io_colours_unload

  _io_colours_unescape

  _io_colours_unload.mock.assert_called_once_with ""
}

test_io_colours_unescape__reloads_colours_without_force() {
  _mock.create _io_colours_load
  _io_colours_load.mock.set.keywords "RPI_IO_COLOUR_FORCE_BOOLEAN"

  _io_colours_unescape

  _io_colours_load.mock.assert_called_once_with \
    "RPI_IO_COLOUR_FORCE_BOOLEAN()"
}

test_io_colours_unescape__calls_dependencies_in_expected_sequence() {
  _mock.create _io_colours_unload
  _mock.create _io_colours_load
  _mock.sequence.record.start

  _io_colours_unescape

  _mock.sequence.assert_is \
    "_io_colours_unload" \
    "_io_colours_load"
}

test_io_colours_unescape__restores_the_theme_values() {
  local STDLIB_COLOUR_BLUE="test_value_1"
  local STDLIB_COLOUR_GREEN="test_value_2"
  local STDLIB_COLOUR_GREY="test_value_3"
  local STDLIB_COLOUR_LIGHT_BLUE="test_value_4"
  local STDLIB_COLOUR_LIGHT_GREEN="test_value_5"
  local STDLIB_COLOUR_LIGHT_RED="test_value_6"
  local STDLIB_COLOUR_RED="test_value_7"
  local THEME_BRACKETS_STYLE_1="BLUE"
  local THEME_BRACKETS_STYLE_2="GREEN"
  local THEME_DETAIL="GREY"
  local THEME_DEVICE="RED"
  local THEME_DISK_GAUGE_SPACE_CRITICAL="LIGHT_BLUE"
  local THEME_DISK_INDICATOR_SPACE_FREE="LIGHT_GREEN"
  local THEME_LOGGER_ERROR="LIGHT_RED"

  _io_colours_escape

  _io_colours_unescape

  assert_equals "${STDLIB_COLOUR_GREY}" "${THEME_DETAIL}"
  assert_equals "${STDLIB_COLOUR_BLUE}" "${THEME_BRACKETS_STYLE_1}"
  assert_equals "${STDLIB_COLOUR_GREEN}" "${THEME_BRACKETS_STYLE_2}"
  assert_equals "${STDLIB_COLOUR_RED}" "${THEME_DEVICE}"
  assert_equals "${STDLIB_COLOUR_LIGHT_BLUE}" "${THEME_DISK_GAUGE_SPACE_CRITICAL}"
  assert_equals "${STDLIB_COLOUR_LIGHT_GREEN}" "${THEME_DISK_INDICATOR_SPACE_FREE}"
  assert_equals "${STDLIB_COLOUR_LIGHT_RED}" "${THEME_LOGGER_ERROR}"
}

test_io_colours_unescape__restores_the_theme_nc_value() {
  local STDLIB_COLOUR_NC="expected_value"
  local THEME_NC="NC"

  _io_colours_escape

  _io_colours_unescape

  assert_equals "${STDLIB_COLOUR_NC}" "${THEME_NC}"
}
