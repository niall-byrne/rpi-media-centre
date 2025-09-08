#!/bin/bash

setup() {
  _mock.create _dependencies_enforce
  _mock.create _dependencies_requirement_generic
}

test_dependencies_group_installer__calls_correct_dependency_functions() {
  _dependencies_group_installer

  _dependencies_enforce.mock.assert_calls_are \
    "1(envsubst) 2(The application envsubst) 3(Please consider running: sudo apt-get install gettext-base)" \
    "1(systemd) 2(The application systemd) 3(  - You may be using a different init system, that's ok, but it's not officially supported."$'\n'"  - It's totally feasible to use a generic cron job to run the backup scheduler, but this is something that's hands on right now.)"

  _dependencies_requirement_generic.mock.assert_calls_are \
    "1(git)"
}
