#!/bin/bash

setup() {
  _mock.create _security_validate_ids
  _mock.create _security_validate_names
}

test_security_validate__calls_security_validate_ids() {
  _security_validate

  _security_validate_ids.mock.assert_called_once_with ""
}

test_security_validate__calls_security_validate_names() {
  _security_validate

  _security_validate_names.mock.assert_called_once_with ""
}
