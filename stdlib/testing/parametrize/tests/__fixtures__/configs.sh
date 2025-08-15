#!/bin/bash

# stdlib testing parametrize configuration test fixtures

export SIMPLE_CONFIG_ONE=(
  "@fixture config_1_mocked_fixture_1"
  "@fixture config_1_mocked_fixture_2"
  "VAR_1;VAR_2;VAR_3"
  "config_1_scenario_1;config1-scenario1-value1;config1-scenario1-value2;config1-scenario1-value3"
  "config_1_scenario_2;config1-scenario2-value1;config1-scenario2-value2;config1-scenario2-value3"
  "config_1_scenario_3;config1-scenario3-value1;config1-scenario3-value2;config1-scenario3-value3"
)

export SIMPLE_CONFIG_TWO=(
  "@fixture config_2_mocked_fixture_1"
  "@fixture config_2_mocked_fixture_2"
  "VAR_1;VAR_2;VAR_3"
  "config_2_scenario_1;config2-scenario1-value1;config2-scenario1-value2;config2-scenario1-value3"
  "config_2_scenario_2;config2-scenario2-value1;config2-scenario2-value2;config2-scenario2-value3"
  "config_2_scenario_3;config2-scenario3-value1;config2-scenario3-value2;config2-scenario3-value3"
)

export SIMPLE_CONFIG_THREE=(
  "@fixture config_3_mocked_fixture_1"
  "@fixture config_3_mocked_fixture_2"
  "NEW_VAR_1;NEW_VAR_2;NEW_VAR_3"
  "config_3_scenario_1;config3-scenario1-value1;config3-scenario1-value2;config3-scenario1-value3"
  "config_3_scenario_2;config3-scenario2-value1;config3-scenario2-value2;config3-scenario2-value3"
  "config_3_scenario_3;config3-scenario3-value1;config3-scenario3-value2;config3-scenario3-value3"
)

export SIMPLE_CONFIG_THREE=(
  "@fixture config_3_mocked_fixture_1"
  "@fixture config_3_mocked_fixture_2"
  "NEW_VAR_1;NEW_VAR_2;NEW_VAR_3"
  "config_3_scenario_1;config3-scenario1-value1;config3-scenario1-value2;config3-scenario1-value3"
  "config_3_scenario_2;config3-scenario2-value1;config3-scenario2-value2;config3-scenario2-value3"
  "config_3_scenario_3;config3-scenario3-value1;config3-scenario3-value2;config3-scenario3-value3"
)

export INVALID_CONFIG_ONE=(
  "@fixture config_3_mocked_fixture_1"
  "@fixture config_3_mocked_fixture_2"
  "VAR_1;VAR_2;VAR_3"
  "config_3_scenario_1;config3-scenario1-value2;config3-scenario1-value3"
  "config_3_scenario_2;config3-scenario2-value1;config3-scenario2-value2;config3-scenario2-value3"
  "config_3_scenario_3;config3-scenario3-value1;config3-scenario3-value2;config3-scenario3-value3"
)

export INVALID_CONFIG_TWO=(
  "@fixture config_3_mocked_fixture_1"
  "@fixture config_3_mocked_fixture_2"
  "VAR_1;VAR_2;VAR_3"
  "duplicate_scenario_1;config3-scenario1-value1;config3-scenario1-value2;config3-scenario1-value3"
  "duplicate_scenario_1;config3-scenario2-value1;config3-scenario2-value2;config3-scenario2-value3"
)
