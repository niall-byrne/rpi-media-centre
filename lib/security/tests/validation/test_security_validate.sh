#!/bin/bash

setup() {
  _mock.create _security_validation_ids
  _mock.create _security_validation_names
}

test_security_validation__calls_security_validation_ids() {
  _security_validation

  _security_validation_ids.mock.assert_called_once_with ""
}

test_security_validation__calls_security_validation_names() {
  _security_validation

  _security_validation_names.mock.assert_called_once_with ""
}
