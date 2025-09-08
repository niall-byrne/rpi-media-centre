#!/bin/bash

setup() {
  _mock.create _cli_compiler_query_is_compilation_required
  _mock.create _cli_compiler_query_is_compilation_memory_only
  _mock.create _cli_make_build_folder
  _mock.create _cli_compiler_cli
  _mock.create stdlib.security.path.secure
  _mock.create source
}

@parametrize_with_paths() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_CLI_COMPILATION_PATH" \
    "scenario1;/tmp/cli1.sh" \
    "scenario2;/tmp/cli2.sh"
}

# shellcheck disable=SC2034
test_cli_bootstrap__@vary__compilation_required______memory_only______calls_make_build_folder() {
  local RPI_PATH_COMPILED_CLI="${TEST_CLI_COMPILATION_PATH}"
  local RPI_SVC_USERNAME="${TEST_USERNAME}"
  local RPI_SVC_GROUPNAME="${TEST_GROUPNAME}"

  _cli_compiler_query_is_compilation_required.mock.set.rc 0
  _cli_compiler_query_is_compilation_memory_only.mock.set.rc 0

  _cli_bootstrap

  _cli_make_build_folder.mock.assert_not_called
}

@parametrize_with_paths \
  test_cli_bootstrap__@vary__compilation_required______memory_only______calls_make_build_folder

# shellcheck disable=SC2034
test_cli_bootstrap__@vary__compilation_required______not_memory_only__calls_make_build_folder() {
  local RPI_PATH_COMPILED_CLI="${TEST_CLI_COMPILATION_PATH}"

  _cli_compiler_query_is_compilation_required.mock.set.rc 0
  _cli_compiler_query_is_compilation_memory_only.mock.set.rc 1

  _cli_bootstrap

  _cli_make_build_folder.mock.assert_called_once_with ""
}

@parametrize_with_paths \
  test_cli_bootstrap__@vary__compilation_required______not_memory_only__calls_make_build_folder

# shellcheck disable=SC2034
test_cli_bootstrap__@vary__compilation_not_required__memory_only______does_not_call_make_build_folder() {
  local RPI_PATH_COMPILED_CLI="${TEST_CLI_COMPILATION_PATH}"

  _cli_compiler_query_is_compilation_required.mock.set.rc 1
  _cli_compiler_query_is_compilation_memory_only.mock.set.rc 0

  _cli_bootstrap

  _cli_make_build_folder.mock.assert_not_called
}

@parametrize_with_paths \
  test_cli_bootstrap__@vary__compilation_not_required__memory_only______does_not_call_make_build_folder

# shellcheck disable=SC2034
test_cli_bootstrap__@vary__compilation_not_required__not_memory_only__does_not_call_make_build_folder() {
  local RPI_PATH_COMPILED_CLI="${TEST_CLI_COMPILATION_PATH}"

  _cli_compiler_query_is_compilation_required.mock.set.rc 1
  _cli_compiler_query_is_compilation_memory_only.mock.set.rc 1

  _cli_bootstrap

  _cli_make_build_folder.mock.assert_not_called
}

@parametrize_with_paths \
  test_cli_bootstrap__@vary__compilation_not_required__not_memory_only__does_not_call_make_build_folder

# shellcheck disable=SC2034
test_cli_bootstrap__@vary__compilation_required______memory_only______calls_compiler_cli() {
  local RPI_PATH_COMPILED_CLI="${TEST_CLI_COMPILATION_PATH}"

  _cli_compiler_query_is_compilation_required.mock.set.rc 0
  _cli_compiler_query_is_compilation_memory_only.mock.set.rc 0

  _cli_bootstrap

  _cli_compiler_cli.mock.assert_called_once_with ""
}

@parametrize_with_paths \
  test_cli_bootstrap__@vary__compilation_required______memory_only______calls_compiler_cli

# shellcheck disable=SC2034
test_cli_bootstrap__@vary__compilation_required______not_memory_only__calls_compiler_cli() {
  local RPI_PATH_COMPILED_CLI="${TEST_CLI_COMPILATION_PATH}"

  _cli_compiler_query_is_compilation_required.mock.set.rc 0
  _cli_compiler_query_is_compilation_memory_only.mock.set.rc 1

  _cli_bootstrap

  _cli_compiler_cli.mock.assert_called_once_with ""
}

@parametrize_with_paths \
  test_cli_bootstrap__@vary__compilation_required______not_memory_only__calls_compiler_cli

# shellcheck disable=SC2034
test_cli_bootstrap__@vary__compilation_not_required__memory_only______does_not_call_compiler_cli() {
  local RPI_PATH_COMPILED_CLI="${TEST_CLI_COMPILATION_PATH}"

  _cli_compiler_query_is_compilation_required.mock.set.rc 1
  _cli_compiler_query_is_compilation_memory_only.mock.set.rc 0

  _cli_bootstrap

  _cli_compiler_cli.mock.assert_not_called
}

@parametrize_with_paths \
  test_cli_bootstrap__@vary__compilation_not_required__memory_only______does_not_call_compiler_cli

# shellcheck disable=SC2034
test_cli_bootstrap__@vary__compilation_not_required__not_memory_only__does_not_call_compiler_cli() {
  local RPI_PATH_COMPILED_CLI="${TEST_CLI_COMPILATION_PATH}"

  _cli_compiler_query_is_compilation_required.mock.set.rc 1
  _cli_compiler_query_is_compilation_memory_only.mock.set.rc 1

  _cli_bootstrap

  _cli_compiler_cli.mock.assert_not_called
}

@parametrize_with_paths \
  test_cli_bootstrap__@vary__compilation_not_required__not_memory_only__does_not_call_compiler_cli

# shellcheck disable=SC2034
test_cli_bootstrap__@vary__compilation_required______memory_only______does_not_call_path_secure() {
  local RPI_PATH_COMPILED_CLI="${TEST_CLI_COMPILATION_PATH}"

  _cli_compiler_query_is_compilation_required.mock.set.rc 0
  _cli_compiler_query_is_compilation_memory_only.mock.set.rc 0

  _cli_bootstrap

  stdlib.security.path.secure.mock.assert_not_called
}

@parametrize_with_paths \
  test_cli_bootstrap__@vary__compilation_required______memory_only______does_not_call_path_secure

# shellcheck disable=SC2034
test_cli_bootstrap__@vary__compilation_required______not_memory_only__calls_path_secure() {
  local RPI_PATH_COMPILED_CLI="${TEST_CLI_COMPILATION_PATH}"

  _cli_compiler_query_is_compilation_required.mock.set.rc 0
  _cli_compiler_query_is_compilation_memory_only.mock.set.rc 1

  _cli_bootstrap

  stdlib.security.path.secure.mock.assert_called_once_with \
    "1(${TEST_CLI_COMPILATION_PATH}) 2(root) 3(root) 4(640)"
}

@parametrize_with_paths \
  test_cli_bootstrap__@vary__compilation_required______not_memory_only__calls_path_secure

# shellcheck disable=SC2034
test_cli_bootstrap__@vary__compilation_not_required__memory_only______does_not_call_path_secure() {
  local RPI_PATH_COMPILED_CLI="${TEST_CLI_COMPILATION_PATH}"

  _cli_compiler_query_is_compilation_required.mock.set.rc 1
  _cli_compiler_query_is_compilation_memory_only.mock.set.rc 0

  _cli_bootstrap

  stdlib.security.path.secure.mock.assert_not_called
}

@parametrize_with_paths \
  test_cli_bootstrap__@vary__compilation_not_required__memory_only______does_not_call_path_secure

# shellcheck disable=SC2034
test_cli_bootstrap__@vary__compilation_not_required__not_memory_only__calls_path_secure() {
  local RPI_PATH_COMPILED_CLI="${TEST_CLI_COMPILATION_PATH}"

  _cli_compiler_query_is_compilation_required.mock.set.rc 1
  _cli_compiler_query_is_compilation_memory_only.mock.set.rc 1

  _cli_bootstrap

  stdlib.security.path.secure.mock.assert_called_once_with \
    "1(${TEST_CLI_COMPILATION_PATH}) 2(root) 3(root) 4(640)"
}

@parametrize_with_paths \
  test_cli_bootstrap__@vary__compilation_not_required__not_memory_only__calls_path_secure

# shellcheck disable=SC2034
test_cli_bootstrap__@vary__compilation_required______memory_only______sources_cli() {
  local RPI_PATH_COMPILED_CLI="${TEST_CLI_COMPILATION_PATH}"

  _cli_compiler_query_is_compilation_required.mock.set.rc 0
  _cli_compiler_query_is_compilation_memory_only.mock.set.rc 0

  _cli_bootstrap

  source.mock.assert_not_called
}

@parametrize_with_paths \
  test_cli_bootstrap__@vary__compilation_required______memory_only______sources_cli

# shellcheck disable=SC2034
test_cli_bootstrap__@vary__compilation_required______not_memory_only__sources_cli() {
  local RPI_PATH_COMPILED_CLI="${TEST_CLI_COMPILATION_PATH}"

  _cli_compiler_query_is_compilation_required.mock.set.rc 0
  _cli_compiler_query_is_compilation_memory_only.mock.set.rc 1

  _cli_bootstrap

  source.mock.assert_called_once_with \
    "1(${TEST_CLI_COMPILATION_PATH})"
}

@parametrize_with_paths \
  test_cli_bootstrap__@vary__compilation_required______not_memory_only__sources_cli

# shellcheck disable=SC2034
test_cli_bootstrap__@vary__compilation_not_required__memory_only______sources_cli() {
  local RPI_PATH_COMPILED_CLI="${TEST_CLI_COMPILATION_PATH}"

  _cli_compiler_query_is_compilation_required.mock.set.rc 1
  _cli_compiler_query_is_compilation_memory_only.mock.set.rc 0

  _cli_bootstrap

  source.mock.assert_not_called
}

@parametrize_with_paths \
  test_cli_bootstrap__@vary__compilation_not_required__memory_only______sources_cli

# shellcheck disable=SC2034
test_cli_bootstrap__@vary__compilation_not_required__not_memory_only__sources_cli() {
  local RPI_PATH_COMPILED_CLI="${TEST_CLI_COMPILATION_PATH}"

  _cli_compiler_query_is_compilation_required.mock.set.rc 1
  _cli_compiler_query_is_compilation_memory_only.mock.set.rc 1

  _cli_bootstrap

  source.mock.assert_called_once_with \
    "1(${TEST_CLI_COMPILATION_PATH})"
}

@parametrize_with_paths \
  test_cli_bootstrap__@vary__compilation_not_required__not_memory_only__sources_cli
