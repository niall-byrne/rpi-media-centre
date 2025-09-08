#!/bin/bash

setup() {
  _mock.create _dependencies_requirement_generic
}

test_dependencies_group_containers__calls_correct_dependency_functions() {
  _dependencies_group_containers

  _dependencies_requirement_generic.mock.assert_calls_are \
    "1(curl)" \
    "1(docker)"
}
