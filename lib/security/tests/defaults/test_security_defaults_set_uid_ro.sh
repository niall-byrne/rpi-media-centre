#!/bin/bash

setup() {
  _mock.create stdlib.security.get.unused_uid
}

test_security_defaults_set_uid_ro__uid_is_set______uses_existing_value() {
  RPI_SVC_UID_RO="999"

  _security_defaults_set_uid_ro

  assert_equals "999" "${RPI_SVC_UID_RO}"
}

test_security_defaults_set_uid_ro__uid_is_not_set__generates_new_id() {
  RPI_SVC_UID_RO=""
  stdlib.security.get.unused_uid.mock.set.stdout "1001"

  _security_defaults_set_uid_ro

  stdlib.security.get.unused_uid.mock.assert_called_once_with ""
}

test_security_defaults_set_uid_ro__uid_is_not_set__sets_new_id() {
  RPI_SVC_UID_RO=""
  stdlib.security.get.unused_uid.mock.set.stdout "1001"

  _security_defaults_set_uid_ro

  assert_equals "1001" "${RPI_SVC_UID_RO}"
}
