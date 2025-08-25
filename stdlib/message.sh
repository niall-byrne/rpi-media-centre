#!/bin/bash

# stdlib messages library

builtin set -eo pipefail

stdlib.message.get() {
  # $1: the message key to retrieve
  # $2: interpolation option 1
  # $3: interpolation option 2
  # $4: interpolation option 3

  local key="${1}"
  local message
  local option1="${2}"
  local option2="${3}"
  local option3="${4}"
  local required_options=0
  local return_status=0

  case "${key}" in
    ARGUMENT_REQUIREMENTS_VIOLATION)
      required_options=2
      message="Expected '${option1}' required argument(s) and '${option2}' optional argument(s)."
      ;;
    ARGUMENT_REQUIREMENTS_VIOLATION_DETAIL)
      required_options=1
      message="Received '${option1}' argument(s)!"
      ;;
    ARGUMENT_REQUIREMENTS_VIOLATION_NULL)
      required_options=1
      message="Argument '${option1}' was null and is not null safe!"
      ;;
    ARGUMENTS_INVALID)
      required_options=0
      message="Invalid arguments provided!"
      ;;
    ARRAY_ARE_EQUAL)
      required_options=2
      message="The arrays '${option1}' and '${option2}' are equal!"
      ;;
    ARRAY_ELEMENT_MISMATCH)
      required_options=3
      message="At index '${option2}': the array '${option1}' has element '${option3}'"
      ;;
    ARRAY_IS_EMPTY)
      required_options=1
      message="The array '${option1}' is empty!"
      ;;
    ARRAY_IS_NOT_EMPTY)
      required_options=1
      message="The array '${option1}' is not empty!"
      ;;
    ARRAY_LENGTH_MISMATCH)
      required_options=2
      message="The array '${option1}' has length '${option2}'"
      ;;
    ARRAY_VALUE_FOUND)
      required_options=2
      message="The value '${option1}' is found in the '${option2}' array!"
      ;;
    ARRAY_VALUE_NOT_FOUND)
      required_options=2
      message="The value '${option1}' is not found in the '${option2}' array!"
      ;;
    COLOUR_INITIALIZE_ERROR)
      required_options=0
      message="Terminal colours could not be initialized!"
      ;;
    COLOUR_INITIALIZE_ERROR_TERM)
      required_options=0
      message="Consider checking the 'TERM' environment variable."
      ;;
    COLOUR_NOT_DEFINED)
      required_options=1
      message="The colour '${option1}' is not defined!"
      ;;
    FS_PATH_DOES_NOT_EXIST)
      required_options=1
      message="The path '${option1}' does not exist on the filesystem!"
      ;;
    FS_PATH_EXISTS)
      required_options=1
      message="The path '${option1}' exists on the filesystem!"
      ;;
    FS_PATH_IS_NOT_A_FILE)
      required_options=1
      message="The path '${option1}' is not a valid filesystem file!"
      ;;
    FS_PATH_IS_NOT_A_FOLDER)
      required_options=1
      message="The path '${option1}' is not a valid filesystem folder!"
      ;;
    FUNCTION_NAME_INVALID)
      required_options=1
      message="The value '${option1}' is not a valid function name!"
      ;;
    IS_ARRAY)
      required_options=1
      message="The value '${option1}' is an array!"
      ;;
    IS_EQUAL)
      required_options=1
      message="A value equal to '${option1}' cannot be used!"
      ;;
    IS_FN)
      required_options=1
      message="The value '${option1}' is a function!"
      ;;
    IS_NOT_ALPHABETIC)
      required_options=1
      message="The value '${option1}' is not a set alphabetic only string!"
      ;;
    IS_NOT_ALPHA_NUMERIC)
      required_options=1
      message="The value '${option1}' is not a set alpha-numeric only string!"
      ;;
    IS_NOT_ARRAY)
      required_options=1
      message="The value '${option1}' is not an array!"
      ;;
    IS_NOT_BOOLEAN)
      required_options=1
      message="The value '${option1}' is not a set string containing a boolean (0 or 1)!"
      ;;
    IS_NOT_CHAR)
      required_options=1
      message="The value '${option1}' is not a set string containing a single char!"
      ;;
    IS_NOT_DIGIT)
      required_options=1
      message="The value '${option1}' is not a set string containing a digit!"
      ;;
    IS_NOT_FN)
      required_options=1
      message="The value '${option1}' is not a function!"
      ;;
    IS_NOT_INTEGER)
      required_options=1
      message="The value '${option1}' is not a set string containing an integer!"
      ;;
    IS_NOT_INTEGER_IN_RANGE)
      required_options=3
      message="The value '${option3}' is not a set string containing an integer in the inclusive range ${option1} to ${option2}!"
      ;;
    IS_NOT_OCTAL_PERMISSION)
      required_options=1
      message="The value '${option1}' is not a set string containing an octal file permission!"
      ;;
    IS_NOT_SET_STRING)
      required_options=1
      message="The value '${option1}' is not a set string!"
      ;;
    REGEX_DOES_NOT_MATCH)
      required_options=2
      message="The regex '${option1}' does not match the value '${option2}'!"
      ;;
    SECURITY_INSECURE_GROUP_OWNERSHIP)
      required_options=1
      message="SECURITY: The group ownership on '${option1}' is not secure!"
      ;;
    SECURITY_INSECURE_OWNERSHIP)
      required_options=1
      message="SECURITY: The ownership on '${option1}' is not secure!"
      ;;
    SECURITY_INSECURE_PERMISSIONS)
      required_options=1
      message="SECURITY: The permissions on '${option1}' are not secure!"
      ;;
    SECURITY_MUST_BE_RUN_AS_ROOT)
      required_options=0
      message="SECURITY: This script must be run as root."
      ;;
    SECURITY_SUGGEST_CHGRP)
      required_options=2
      message="Please consider running: sudo chgrp ${option1} ${option2}"
      ;;
    SECURITY_SUGGEST_CHMOD)
      required_options=2
      message="Please consider running: sudo chmod ${option1} ${option2}"
      ;;
    SECURITY_SUGGEST_CHOWN)
      required_options=2
      message="Please consider running: sudo chown ${option1} ${option2}"
      ;;
    STDIN_DEFAULT_CONFIRMATION_PROMPT)
      required_options=0
      message="Are you sure you wish to proceed (Y/n) ? "
      ;;
    STDIN_DEFAULT_PAUSE_PROMPT)
      required_options=0
      message="Press any key to continue ... " # noqa
      ;;
    STDIN_DEFAULT_VALUE_PROMPT)
      required_options=0
      message="Enter a value: "
      ;;
    TRACEBACK_HEADER)
      required_options=0
      message="Callstack:"
      ;;
    "")
      required_options=0
      return_status=126
      message="$(stdlib.message.get ARGUMENTS_INVALID)"
      ;;
    *)
      required_options=0
      return_status=126
      message="Unknown message key '${key}'"
      ;;
  esac

  (("${#@}" == 1 + required_options)) || {
    stdlib.logger.error "$(stdlib.message.get ARGUMENTS_INVALID)"
    return 127
  }

  ((return_status == 0)) || {
    stdlib.logger.error "${message}"
    return ${return_status}
  }

  builtin echo -n "${message}"
}
