#!/bin/bash

setup() {
  _mock.create _security_id_get_uid_next_available
  _security_id_get_uid_next_available.mock.set.stdout "1001"
}

test_security_defaults_set_uid_ro__existing_value_____returns_existing_value() {
  RPI_SVC_UID_RO="99"

  _security_defaults_set_uid_ro

  assert_equals "99" "${RPI_SVC_UID_RO}"
}

test_security_defaults_set_uid_ro__no_existing_value__calls_security_id_get_uid_next_available() {
  RPI_SVC_UID_RO=""

  _security_defaults_set_uid_ro

  _security_id_get_uid_next_available.mock.assert_called_once_with ""
}

test_security_defaults_set_uid_ro__no_existing_value__returns_generated_value() {
  RPI_SVC_UID_RO=""

  _security_defaults_set_uid_ro

  assert_equals "1001" "${RPI_SVC_UID_RO}"
}
