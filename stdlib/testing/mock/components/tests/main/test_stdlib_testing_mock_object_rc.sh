#!/bin/bash

setup() {
  _mock.create test_mock
}

test_mock_object_rc_behaviour__@vary() {
  if [[ -n "${MANUAL_RC}" ]]; then
    test_mock.mock.set.rc "${MANUAL_RC}"
  fi
  if [[ -n "${SUBCOMMAND_RC}" ]]; then
    test_mock.mock.set.subcommand "return ${SUBCOMMAND_RC}"
  fi
  if [[ -n "${SIDE_EFFECT_RC}" ]]; then
    test_mock.mock.set.side_effects "return ${SIDE_EFFECT_RC}"
  fi

  _capture.rc test_mock

  assert_rc "${EXPECTED_RC}"
}

@parametrize \
  test_mock_object_rc_behaviour__@vary \
  "MANUAL_RC;SUBCOMMAND_RC;SIDE_EFFECT_RC;EXPECTED_RC" \
  "not_manually_set__subcommand_failure__side_effect_not_set__returns_subcommand_rc;;5;;5" \
  "not_manually_set__subcommand_failure__side_effect_failure__returns_subcommand_rc;;5;10;5" \
  "not_manually_set__subcommand_failure__side_effect_passes___returns_subcommand_rc;;5;0;5" \
  "not_manually_set__subcommand_not_set__side_effect_not_set__returns_zero_rc;;;;0" \
  "not_manually_set__subcommand_not_set__side_effect_failure__returns_side_effect_rc;;;10;10" \
  "not_manually_set__subcommand_not_set__side_effect_passes___returns_side_effect_rc;;;0;0" \
  "not_manually_set__subcommand_passes___side_effect_not_set__returns_subcommand_rc;;0;;0" \
  "not_manually_set__subcommand_passes___side_effect_failure__returns_side_effect_rc;;0;10;10" \
  "not_manually_set__subcommand_passes___side_effect_passes___returns_zero_rc;;0;0;0" \
  "manually_zero_____subcommand_failure__side_effect_not_set__returns_subcommand_rc;0;5;;5" \
  "manually_zero_____subcommand_failure__side_effect_failure__returns_subcommand_rc;0;5;10;5" \
  "manually_zero_____subcommand_failure__side_effect_passes___returns_subcommand_rc;0;5;0;5" \
  "manually_zero_____subcommand_not_set__side_effect_not_set__returns_zero_rc;0;;;0" \
  "manually_zero_____subcommand_not_set__side_effect_failure__returns_side_effect_rc;0;;10;10" \
  "manually_zero_____subcommand_not_set__side_effect_passes___returns_side_effect_rc;0;;0;0" \
  "manually_zero_____subcommand_passes___side_effect_not_set__returns_subcommand_rc;0;0;;0" \
  "manually_zero_____subcommand_passes___side_effect_failure__returns_side_effect_rc;0;0;10;10" \
  "manually_zero_____subcommand_passes___side_effect_passes___returns_zero_rc;0;0;0;0" \
  "manually_fails____subcommand_failure__side_effect_not_set__returns_manual_rc;127;5;;127" \
  "manually_fails____subcommand_failure__side_effect_failure__returns_manual_rc;127;5;10;127" \
  "manually_fails____subcommand_failure__side_effect_passes___returns_manual_rc;127;5;0;127" \
  "manually_fails____subcommand_not_set__side_effect_not_set__returns_manual_rc;127;;;127" \
  "manually_fails____subcommand_not_set__side_effect_failure__returns_manual_rc;127;;10;127" \
  "manually_fails____subcommand_not_set__side_effect_passes___returns_manual_rc;127;;0;127" \
  "manually_fails____subcommand_passes___side_effect_not_set__returns_manual_rc;127;0;;127" \
  "manually_fails____subcommand_passes___side_effect_failure__returns_manual_rc;127;0;10;127" \
  "manually_fails____subcommand_passes___side_effect_passes___returns_manual_rc;127;0;0;127"
