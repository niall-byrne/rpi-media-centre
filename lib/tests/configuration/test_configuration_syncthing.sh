#!/bin/bash

setup() {
  _mock.create _configuration_syncthing_setting
}

test_configuration_syncthing__calls_setting_for_username() {
  _configuration_syncthing

  _configuration_syncthing_setting.mock.assert_any_call_is \
    "1(RPI_SYNCTHING_CREDENTIALS_USERNAME) 2(gui) 3(user)"
}

test_configuration_syncthing__calls_setting_for_password() {
  _configuration_syncthing

  _configuration_syncthing_setting.mock.assert_any_call_is \
    "1(RPI_SYNCTHING_CREDENTIALS_PASSWORD) 2(gui) 3(password)"
}
