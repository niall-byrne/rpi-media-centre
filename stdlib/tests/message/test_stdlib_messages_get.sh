#!/bin/bash

setup() {
  _mock.create stdlib.logger.error
}

@parametrize_with_arg_combos() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args_______________________returns_status_code_127;;127" \
    "extra_args____________________returns_status_code_127;ARGUMENTS_INVALID|two|three|four|five;127" \
    "invalid_arguments_____________returns_status_code_126;INVALID_KEY;126" \
    "valid_argument________________returns_status_code___0;ARGUMENTS_INVALID;0" \
    "valid_arguments_with_options__returns_status_code___0;ARGUMENTS_INVALID;0"
}

@parametrize_with_message_content() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_STDOUT" \
    "argument_requirements_violation;ARGUMENT_REQUIREMENTS_VIOLATION|2|1;Expected '2' required argument(s) and '1' optional argument(s)." \
    "argument_requirements_violation_detail;ARGUMENT_REQUIREMENTS_VIOLATION_DETAIL|3;Received '3' argument(s)!" \
    "argument_requirements_violation_null;ARGUMENT_REQUIREMENTS_VIOLATION_NULL|my_arg;Argument 'my_arg' was null and is not null safe!" \
    "arguments_invalid;ARGUMENTS_INVALID;Invalid arguments provided!" \
    "array_are_equal;ARRAY_ARE_EQUAL|array1|array2;The arrays 'array1' and 'array2' are equal!" \
    "array_element_mismatch;ARRAY_ELEMENT_MISMATCH|my_array|0|my_value;At index '0': the array 'my_array' has element 'my_value'" \
    "array_is_empty;ARRAY_IS_EMPTY|my_array;The array 'my_array' is empty!" \
    "array_is_not_empty;ARRAY_IS_NOT_EMPTY|my_array;The array 'my_array' is not empty!" \
    "array_length_mismatch;ARRAY_LENGTH_MISMATCH|my_array|10;The array 'my_array' has length '10'" \
    "array_value_found;ARRAY_VALUE_FOUND|my_value|my_array;The value 'my_value' is found in the 'my_array' array!" \
    "array_value_not_found;ARRAY_VALUE_NOT_FOUND|my_value|my_array;The value 'my_value' is not found in the 'my_array' array!" \
    "colour_initialize_error;COLOUR_INITIALIZE_ERROR;Terminal colours could not be initialized!" \
    "colour_initialize_error_term;COLOUR_INITIALIZE_ERROR_TERM;Consider checking the 'TERM' environment variable." \
    "colour_not_defined;COLOUR_NOT_DEFINED|RED;The colour 'RED' is not defined!" \
    "fs_path_does_not_exist;FS_PATH_DOES_NOT_EXIST|/tmp/foo;The path '/tmp/foo' does not exist on the filesystem!" \
    "fs_path_exists;FS_PATH_EXISTS|/tmp/foo;The path '/tmp/foo' exists on the filesystem!" \
    "fs_path_is_not_a_file;FS_PATH_IS_NOT_A_FILE|/tmp/foo;The path '/tmp/foo' is not a valid filesystem file!" \
    "fs_path_is_not_a_folder;FS_PATH_IS_NOT_A_FOLDER|/tmp/foo;The path '/tmp/foo' is not a valid filesystem folder!" \
    "function_name_invalid;FUNCTION_NAME_INVALID|my_func;The value 'my_func' is not a valid function name!" \
    "is_array;IS_ARRAY|value;The value 'value' is an array!" \
    "is_equal;IS_EQUAL|value;A value equal to 'value' cannot be used!" \
    "is_fn;IS_FN|value;The value 'value' is a function!" \
    "is_not_alphabetic;IS_NOT_ALPHABETIC|value;The value 'value' is not a set alphabetic only string!" \
    "is_not_alpha_numeric;IS_NOT_ALPHA_NUMERIC|value;The value 'value' is not a set alpha-numeric only string!" \
    "is_not_array;IS_NOT_ARRAY|value;The value 'value' is not an array!" \
    "is_not_boolean;IS_NOT_BOOLEAN|value;The value 'value' is not a set string containing a boolean (0 or 1)!" \
    "is_not_char;IS_NOT_CHAR|value;The value 'value' is not a set string containing a single char!" \
    "is_not_digit;IS_NOT_DIGIT|value;The value 'value' is not a set string containing a digit!" \
    "is_not_fn;IS_NOT_FN|value;The value 'value' is not a function!" \
    "is_not_integer;IS_NOT_INTEGER|value;The value 'value' is not a set string containing an integer!" \
    "is_not_integer_in_range;IS_NOT_INTEGER_IN_RANGE|1|10|11;The value '11' is not a set string containing an integer in the inclusive range 1 to 10!" \
    "is_not_octal_permission;IS_NOT_OCTAL_PERMISSION|aaa;The value 'aaa' is not a set string containing an octal file permission!" \
    "is_not_set_string;IS_NOT_SET_STRING|value;The value 'value' is not a set string!" \
    "regex_does_not_match;REGEX_DOES_NOT_MATCH|regex|not matching;The regex 'regex' does not match the value 'not matching'!" \
    "security_insecure_group_ownership;SECURITY_INSECURE_GROUP_OWNERSHIP|/tmp/foo;SECURITY: The group ownership on '/tmp/foo' is not secure!" \
    "security_insecure_ownership;SECURITY_INSECURE_OWNERSHIP|/tmp/foo;SECURITY: The ownership on '/tmp/foo' is not secure!" \
    "security_insecure_permissions;SECURITY_INSECURE_PERMISSIONS|/tmp/foo;SECURITY: The permissions on '/tmp/foo' are not secure!" \
    "security_must_be_run_as_root;SECURITY_MUST_BE_RUN_AS_ROOT;SECURITY: This script must be run as root." \
    "security_suggest_chgrp;SECURITY_SUGGEST_CHGRP|wheel|/tmp/foo;Please consider running: sudo chgrp wheel /tmp/foo" \
    "security_suggest_chmod;SECURITY_SUGGEST_CHMOD|0700|/tmp/foo;Please consider running: sudo chmod 0700 /tmp/foo" \
    "security_suggest_chown;SECURITY_SUGGEST_CHOWN|root|/tmp/foo;Please consider running: sudo chown root /tmp/foo" \
    "stdin_default_confirmation_prompt;STDIN_DEFAULT_CONFIRMATION_PROMPT;Are you sure you wish to proceed (Y/n) ? " \
    "stdin_default_pause_prompt;STDIN_DEFAULT_PAUSE_PROMPT;Press any key to continue ... " \
    "stdin_default_value_prompt;STDIN_DEFAULT_VALUE_PROMPT;Enter a value: " \
    "traceback_header;TRACEBACK_HEADER;Callstack:"
}

@parametrize_with_incorrect_arg_counts() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION" \
    "argument_requirements_violation_________no_args______;ARGUMENT_REQUIREMENTS_VIOLATION" \
    "argument_requirements_violation_________too_few_args_;ARGUMENT_REQUIREMENTS_VIOLATION|1" \
    "argument_requirements_violation_________too_many_args;ARGUMENT_REQUIREMENTS_VIOLATION|1|2|3" \
    "argument_requirements_violation_detail__no_args______;ARGUMENT_REQUIREMENTS_VIOLATION_DETAIL" \
    "argument_requirements_violation_detail__too_many_args;ARGUMENT_REQUIREMENTS_VIOLATION_DETAIL|1|2" \
    "argument_requirements_violation_null____no_args______;ARGUMENT_REQUIREMENTS_VIOLATION_NULL" \
    "argument_requirements_violation_null____too_many_args;ARGUMENT_REQUIREMENTS_VIOLATION_NULL|1|2" \
    "arguments_invalid_______________________too_many_args;ARGUMENTS_INVALID|1" \
    "array_are_equal_________________________no_args______;ARRAY_ARE_EQUAL" \
    "array_are_equal_________________________too_few_args_;ARRAY_ARE_EQUAL|1" \
    "array_are_equal_________________________too_many_args;ARRAY_ARE_EQUAL|1|2|3" \
    "array_element_mismatch__________________no_args______;ARRAY_ELEMENT_MISMATCH" \
    "array_element_mismatch__________________too_few_args_;ARRAY_ELEMENT_MISMATCH|1|2" \
    "array_element_mismatch__________________too_many_args;ARRAY_ELEMENT_MISMATCH|1|2|3|4" \
    "array_is_empty__________________________no_args______;ARRAY_IS_EMPTY" \
    "array_is_empty__________________________too_many_args;ARRAY_IS_EMPTY|1|2" \
    "array_is_not_empty______________________no_args______;ARRAY_IS_NOT_EMPTY" \
    "array_is_not_empty______________________too_many_args;ARRAY_IS_NOT_EMPTY|1|2" \
    "array_length_mismatch___________________no_args______;ARRAY_LENGTH_MISMATCH" \
    "array_length_mismatch___________________too_few_args_;ARRAY_LENGTH_MISMATCH|1" \
    "array_length_mismatch___________________too_many_args;ARRAY_LENGTH_MISMATCH|1|2|3" \
    "array_value_found_______________________no_args______;ARRAY_VALUE_FOUND" \
    "array_value_found_______________________too_few_args_;ARRAY_VALUE_FOUND|1" \
    "array_value_found_______________________too_many_args;ARRAY_VALUE_FOUND|1|2|3" \
    "array_value_not_found___________________no_args______;ARRAY_VALUE_NOT_FOUND" \
    "array_value_not_found___________________too_few_args_;ARRAY_VALUE_NOT_FOUND|1" \
    "array_value_not_found___________________too_many_args;ARRAY_VALUE_NOT_FOUND|1|2|3" \
    "colour_initialize_error_________________too_many_args;COLOUR_INITIALIZE_ERROR|1" \
    "colour_initialize_error_term____________too_many_args;COLOUR_INITIALIZE_ERROR_TERM|1" \
    "colour_not_defined______________________no_args______;COLOUR_NOT_DEFINED" \
    "colour_not_defined______________________too_many_args;COLOUR_NOT_DEFINED|1|2" \
    "fs_path_does_not_exist__________________no_args______;FS_PATH_DOES_NOT_EXIST" \
    "fs_path_does_not_exist__________________too_many_args;FS_PATH_DOES_NOT_EXIST|1|2" \
    "fs_path_exists__________________________no_args______;FS_PATH_EXISTS" \
    "fs_path_exists__________________________too_many_args;FS_PATH_EXISTS|1|2" \
    "fs_path_is_not_a_file___________________no_args______;FS_PATH_IS_NOT_A_FILE" \
    "fs_path_is_not_a_file___________________too_many_args;FS_PATH_IS_NOT_A_FILE|1|2" \
    "fs_path_is_not_a_folder_________________no_args______;FS_PATH_IS_NOT_A_FOLDER" \
    "fs_path_is_not_a_folder_________________too_many_args;FS_PATH_IS_NOT_A_FOLDER|1|2" \
    "function_name_invalid___________________no_args______;FUNCTION_NAME_INVALID" \
    "function_name_invalid___________________too_many_args;FUNCTION_NAME_INVALID|1|2" \
    "is_array________________________________no_args______;IS_ARRAY" \
    "is_array________________________________too_many_args;IS_ARRAY|1|2" \
    "is_equal________________________________no_args______;IS_EQUAL" \
    "is_equal________________________________too_many_args;IS_EQUAL|1|2" \
    "is_fn___________________________________no_args______;IS_FN" \
    "is_fn___________________________________too_many_args;IS_FN|1|2" \
    "is_not_alphabetic_______________________no_args______;IS_NOT_ALPHABETIC" \
    "is_not_alphabetic_______________________too_many_args;IS_NOT_ALPHABETIC|1|2" \
    "is_not_alpha_numeric____________________no_args______;IS_NOT_ALPHA_NUMERIC" \
    "is_not_alpha_numeric____________________too_many_args;IS_NOT_ALPHA_NUMERIC|1|2" \
    "is_not_array____________________________no_args______;IS_NOT_ARRAY" \
    "is_not_array____________________________too_many_args;IS_NOT_ARRAY|1|2" \
    "is_not_boolean__________________________no_args______;IS_NOT_BOOLEAN" \
    "is_not_boolean__________________________too_many_args;IS_NOT_BOOLEAN|1|2" \
    "is_not_char_____________________________no_args______;IS_NOT_CHAR" \
    "is_not_char_____________________________too_many_args;IS_NOT_CHAR|1|2" \
    "is_not_digit____________________________no_args______;IS_NOT_DIGIT" \
    "is_not_digit____________________________too_many_args;IS_NOT_DIGIT|1|2" \
    "is_not_fn_______________________________no_args______;IS_NOT_FN" \
    "is_not_fn_______________________________too_many_args;IS_NOT_FN|1|2" \
    "is_not_integer__________________________no_args______;IS_NOT_INTEGER" \
    "is_not_integer__________________________too_many_args;IS_NOT_INTEGER|1|2" \
    "is_not_integer_in_range_________________no_args______;IS_NOT_INTEGER_IN_RANGE" \
    "is_not_integer_in_range_________________too_few_args;IS_NOT_INTEGER_IN_RANGE|1|2" \
    "is_not_integer_in_range_________________too_many_args;IS_NOT_INTEGER_IN_RANGE|1|2|3|4" \
    "is_not_octal_permission_________________no_args______;IS_NOT_OCTAL_PERMISSION" \
    "is_not_octal_permission_________________too_many_args;IS_NOT_OCTAL_PERMISSION|1|2" \
    "is_not_set_string_______________________no_args______;IS_NOT_SET_STRING" \
    "is_not_set_string_______________________too_many_args;IS_NOT_SET_STRING|1|2" \
    "regex_does_not_match____________________no_args______;REGEX_DOES_NOT_MATCH" \
    "regex_does_not_match____________________too_few_args_;REGEX_DOES_NOT_MATCH|1" \
    "regex_does_not_match____________________too_many_args;REGEX_DOES_NOT_MATCH|1|2|3" \
    "security_insecure_group_ownership_______no_args______;SECURITY_INSECURE_GROUP_OWNERSHIP" \
    "security_insecure_group_ownership_______too_many_args;SECURITY_INSECURE_GROUP_OWNERSHIP|1|2" \
    "security_insecure_ownership_____________no_args______;SECURITY_INSECURE_OWNERSHIP" \
    "security_insecure_ownership_____________too_many_args;SECURITY_INSECURE_OWNERSHIP|1|2" \
    "security_insecure_permissions___________no_args______;SECURITY_INSECURE_PERMISSIONS" \
    "security_insecure_permissions___________too_many_args;SECURITY_INSECURE_PERMISSIONS|1|2" \
    "security_must_be_run_as_root____________too_many_args;SECURITY_MUST_BE_RUN_AS_ROOT|1" \
    "security_suggest_chgrp__________________no_args______;SECURITY_SUGGEST_CHGRP" \
    "security_suggest_chgrp__________________too_few_args_;SECURITY_SUGGEST_CHGRP|1" \
    "security_suggest_chgrp__________________too_many_args;SECURITY_SUGGEST_CHGRP|1|2|3" \
    "security_suggest_chmod__________________no_args______;SECURITY_SUGGEST_CHMOD" \
    "security_suggest_chmod__________________too_few_args_;SECURITY_SUGGEST_CHMOD|1" \
    "security_suggest_chmod__________________too_many_args;SECURITY_SUGGEST_CHMOD|1|2|3" \
    "security_suggest_chown__________________no_args______;SECURITY_SUGGEST_CHOWN" \
    "security_suggest_chown__________________too_few_args_;SECURITY_SUGGEST_CHOWN|1" \
    "security_suggest_chown__________________too_many_args;SECURITY_SUGGEST_CHOWN|1|2|3" \
    "stdin_default_confirmation_prompt_______too_many_args;STDIN_DEFAULT_CONFIRMATION_PROMPT|1" \
    "stdin_default_pause_prompt______________too_many_args;STDIN_DEFAULT_PAUSE_PROMPT|1" \
    "stdin_default_value_prompt______________too_many_args;STDIN_DEFAULT_VALUE_PROMPT|1" \
    "traceback_header________________________too_many_args;TRACEBACK_HEADER|1"
}

# shellcheck disable=SC2034
test_stdlib_message_update_get__@vary() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.message.get "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_arg_combos \
  test_stdlib_message_update_get__@vary

# shellcheck disable=SC2034
test_stdlib_message_update_get__valid_argument________________@vary_____returns_correct_message() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.stdout stdlib.message.get "${args[@]}"

  assert_equals "${TEST_EXPECTED_STDOUT}" "${TEST_OUTPUT}"
}

@parametrize_with_message_content \
  test_stdlib_message_update_get__valid_argument________________@vary_____returns_correct_message

test_stdlib_message_update_get__invalid_arguments_____________returns_error_message() {
  _capture.stdout stdlib.message.get "NON_EXISTENT_KEY"

  stdlib.logger.error.mock.assert_called_once_with \
    "1(Unknown message key 'NON_EXISTENT_KEY')"
}

# shellcheck disable=SC2034
test_stdlib_message_update_get__invalid_arg_count_____________@vary__returns_correct_message() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.stdout stdlib.message.get "${args[@]}"

  stdlib.logger.error.mock.assert_called_once_with \
    "1(Invalid arguments provided!)"
}

@parametrize_with_incorrect_arg_counts \
  test_stdlib_message_update_get__invalid_arg_count_____________@vary__returns_correct_message
