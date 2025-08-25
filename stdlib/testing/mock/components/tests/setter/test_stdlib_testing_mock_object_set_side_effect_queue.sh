#!/bin/bash

test_stdlib_testing_mock_object_set_side_effects__@vary__calls_side_effect_as_expected() {
  local side_effects=()

  _mock.create test_mock
  _ARGS_ALLOW_NULL_BOOLEAN=1 stdlib.array.make.from_string side_effects "|" "${SIDE_EFFECTS_DEFINITION}"
  test_mock.mock.set.side_effects "${side_effects[@]}"

  TEST_OUTPUT_1="$(test_mock)"
  TEST_OUTPUT_2="$(test_mock)"
  TEST_OUTPUT_3="$(test_mock)"

  assert_equals "${TEST_EXPECTED_OUTPUT_1}" "${TEST_OUTPUT_1}"
  assert_equals "${TEST_EXPECTED_OUTPUT_2}" "${TEST_OUTPUT_2}"
  assert_equals "${TEST_EXPECTED_OUTPUT_3}" "${TEST_OUTPUT_3}"
}

#_PARAMETRIZE_DEBUG=1

@parametrize \
  test_stdlib_testing_mock_object_set_side_effects__@vary__calls_side_effect_as_expected \
  "SIDE_EFFECTS_DEFINITION;TEST_EXPECTED_OUTPUT_1;TEST_EXPECTED_OUTPUT_2;TEST_EXPECTED_OUTPUT_3" \
  "three_side_effects;echo sandwich|echo pizza|echo wrap;sandwich;pizza;wrap" \
  "two___side_effects;echo biking|echo running;biking;running;;" \
  "one___side_effects;echo workout;workout;;;" \
  "no_elements_______;;;;;"
