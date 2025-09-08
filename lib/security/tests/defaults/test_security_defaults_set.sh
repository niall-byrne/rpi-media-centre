#!/bin/bash

setup() {
  _mock.create _security_defaults_set_username
  _mock.create _security_defaults_set_uid
  _mock.create _security_defaults_set_groupname
  _mock.create _security_defaults_set_gid
  _mock.create _security_defaults_set_uid_ro
}

test_security_defaults_set__@vary_setter_once_without_args() {
  _security_defaults_set

  "${SECURITY_SETTER}.mock.assert_called_once_with" ""
}

@parametrize \
  "test_security_defaults_set__@vary_setter_once_without_args" \
  "SECURITY_SETTER;" \
  "_security_defaults_set_username_;_security_defaults_set_username" \
  "_security_defaults_set_uid______;_security_defaults_set_uid" \
  "_security_defaults_set_groupname;_security_defaults_set_groupname" \
  "_security_defaults_set_gid______;_security_defaults_set_gid" \
  "_security_defaults_set_uid_ro___;_security_defaults_set_uid_ro"
