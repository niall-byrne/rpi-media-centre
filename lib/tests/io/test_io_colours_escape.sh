#!/bin/bash

test_io_colours_escape__force_loads_stdlib_colours() {
  _mock.create _io_colours_load
  _io_colours_load.mock.set.keywords "RPI_IO_COLOUR_FORCE_BOOLEAN"

  _io_colours_escape

  _io_colours_load.mock.assert_called_once_with \
    "RPI_IO_COLOUR_FORCE_BOOLEAN(1)"
}

test_io_colours_escape__reloads_the_theme_content() {
  _mock.create _io_theme_load

  _io_colours_escape

  _io_theme_load.mock.assert_called_once_with ""
}

test_io_colours_escape__escapes_the_theme_values() {
  local THEME_DETAIL="mock_value"
  local THEME_BRACKETS_STYLE_1="mock_value"
  local THEME_BRACKETS_STYLE_2="mock_value"
  local THEME_DEVICE="mock_value"
  local THEME_DISK_GAUGE_SPACE_CRITICAL="mock_value"
  local THEME_DISK_INDICATOR_SPACE_FREE="mock_value"
  local THEME_LOGGER_ERROR="mock_value"

  _io_colours_escape

  assert_equals "${THEME_DETAIL}" "\${THEME_DETAIL}"
  assert_equals "${THEME_BRACKETS_STYLE_1}" "\${THEME_BRACKETS_STYLE_1}"
  assert_equals "${THEME_BRACKETS_STYLE_2}" "\${THEME_BRACKETS_STYLE_2}"
  assert_equals "${THEME_DEVICE}" "\${THEME_DEVICE}"
  assert_equals "${THEME_DISK_GAUGE_SPACE_CRITICAL}" "\${THEME_DISK_GAUGE_SPACE_CRITICAL}"
  assert_equals "${THEME_DISK_INDICATOR_SPACE_FREE}" "\${THEME_DISK_INDICATOR_SPACE_FREE}"
  assert_equals "${THEME_LOGGER_ERROR}" "\${THEME_LOGGER_ERROR}"
}

test_io_colours_escape__escapes_the_theme_nc_value() {
  _io_colours_escape

  assert_equals "${THEME_NC}" "\${THEME_NC}"
}
