#!/bin/bash

setup() {
  _mock.create stdlib.setting.colour.disable
  _mock.create _io_theme_load
}

test_io_colours_unload__disables_stdlib_colours() {
  _io_colours_unload

  stdlib.setting.colour.disable.mock.assert_called_once_with ""
}

test_io_colours_unload__loads_the_theme() {
  _io_colours_unload

  _io_theme_load.mock.assert_called_once_with ""
}
