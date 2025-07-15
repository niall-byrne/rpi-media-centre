#!/bin/bash

# pictl cli compiler cli library

set -eo pipefail

# CLI Column Alignment Settings
RPI_CLI_COLUMN_WIDTH="42"
# shellcheck disable=SC2034
RPI_CLI_COLUMN_ALIGNMENT_WITHOUT_TAB="$((RPI_CLI_COLUMN_WIDTH + 5))"

_cli_compiler_cli() {
  _cli_log_warning "CLI: Compiling ..."

  (
    _io_colours_escape
    time _cli_compiler_configuration_load_to_buffer "_cli_compiler_cli_dispatcher"
  )

  _cli_log_success "CLI: Ready to go!"
}

_cli_compiler_cli_dispatcher() {
  case "${RPI_COMPILER_STAGE}" in
    0)
      _cli_compiler_cli_write_file_header
      ;;
    1)
      _cli_compiler_buffer_assign "RPI_CLI_COMPILER_HEADER"
      ;;
    2)
      _cli_compiler_buffer_assign "RPI_CLI_COMPILER_USAGE_STRING"
      _cli_compiler_cli_function_usage
      _cli_compiler_cli_function_usage_error
      _cli_compiler_cli_process_generated_code "${RPI_CLI_COMPILER_GENERATED_CODE}"
      RPI_CLI_COMPILER_GENERATED_CODE=""
      ;;
    3)
      _cli_compiler_cli_function_command
      _cli_compiler_cli_process_generated_code "${RPI_CLI_COMPILER_GENERATED_CODE}"
      RPI_CLI_COMPILER_GENERATED_CODE=""
      echo "  PICTL: Compiled ${RPI_CLI_COMPILER_HEADER}"
      ;;
    4) ;;
  esac
}

_cli_compiler_cli_function_command() {
  local RPI_CLI_COMPILER_COMMAND_NAME=""
  local RPI_CLI_COMPILER_FUNCTION_CALL=""
  local RPI_CLI_COMPILER_FUNCTION_CALL_BEFORE=""
  local RPI_CLI_COMPILER_FUNCTION_CALL_BEFORE_ALL=""

  RPI_CLI_COMPILER_GENERATED_CODE+="_${RPI_CLI_COMPILER_HEADER}_cli() {\n"

  _cli_compiler_cli_function_command_case_begin

  while IFS= read -r FILE_LINE; do

    if [[ "${FILE_LINE}" == "" ]] ||
      [[ "${FILE_LINE:0:1}" == "#" ]]; then
      continue
    fi

    if [[ "${FILE_LINE:0:1}" == "${RPI_CLI_COMPILER_BEFORE_ALL_COMMAND_MARKER}" ]]; then
      RPI_CLI_COMPILER_FUNCTION_CALL_BEFORE_ALL="${FILE_LINE:1}"
      continue
    fi

    IFS="${RPI_CLI_COMPILER_FIELD_SEPERATOR}" read -r \
      RPI_CLI_COMPILER_COMMAND_NAME \
      RPI_CLI_COMPILER_FUNCTION_CALL_BEFORE \
      RPI_CLI_COMPILER_FUNCTION_CALL \
      <<< "$FILE_LINE"

    _cli_compiler_cli_function_command_case_condition_subcommand

  done <<< "${RPI_CLI_COMPILER_BUFFER}"

  _cli_compiler_cli_function_command_case_condition_help
  _cli_compiler_cli_function_command_case_end
}

_cli_compiler_cli_function_command_case_begin() {
  RPI_CLI_COMPILER_GENERATED_CODE+="  case \"\${1}\" in\n"
}

_cli_compiler_cli_function_command_case_condition_subcommand() {
  RPI_CLI_COMPILER_FUNCTION_CALL="${RPI_CLI_COMPILER_FUNCTION_CALL:-"_${RPI_CLI_COMPILER_HEADER}_cli_${RPI_CLI_COMPILER_COMMAND_NAME}"}"

  RPI_CLI_COMPILER_GENERATED_CODE+="    ${RPI_CLI_COMPILER_COMMAND_NAME})\n"
  RPI_CLI_COMPILER_GENERATED_CODE+="      shift\n"

  if [[ -n "${RPI_CLI_COMPILER_FUNCTION_CALL_BEFORE_ALL}" ]]; then
    RPI_CLI_COMPILER_GENERATED_CODE+="      ${RPI_CLI_COMPILER_FUNCTION_CALL_BEFORE_ALL} \"\$@\"\n"
  fi

  if [[ -n "${RPI_CLI_COMPILER_FUNCTION_CALL_BEFORE}" ]]; then
    RPI_CLI_COMPILER_GENERATED_CODE+="      ${RPI_CLI_COMPILER_FUNCTION_CALL_BEFORE} \"\$@\"\n"
  fi

  RPI_CLI_COMPILER_GENERATED_CODE+="      ${RPI_CLI_COMPILER_FUNCTION_CALL} \"\$@\"\n"
  RPI_CLI_COMPILER_GENERATED_CODE+="      ;;\n"
}

_cli_compiler_cli_function_command_case_condition_help() {
  RPI_CLI_COMPILER_FUNCTION_CALL="_${RPI_CLI_COMPILER_HEADER}_cli_usage"

  RPI_CLI_COMPILER_GENERATED_CODE+="    help)\n"
  RPI_CLI_COMPILER_GENERATED_CODE+="      ${RPI_CLI_COMPILER_FUNCTION_CALL}\n"
  RPI_CLI_COMPILER_GENERATED_CODE+="      ;;\n"

  RPI_CLI_COMPILER_GENERATED_CODE+="    *)\n"
  RPI_CLI_COMPILER_GENERATED_CODE+="      ${RPI_CLI_COMPILER_FUNCTION_CALL}\n"
  RPI_CLI_COMPILER_GENERATED_CODE+="      return 127\n"
  RPI_CLI_COMPILER_GENERATED_CODE+="      ;;\n"
}

_cli_compiler_cli_function_command_case_end() {
  RPI_CLI_COMPILER_GENERATED_CODE+="  esac\n"
  RPI_CLI_COMPILER_GENERATED_CODE+="}\n"
}

_cli_compiler_cli_function_usage() {

  local RPI_CLI_COMPILER_USAGE_LINE_INDEX="0"
  local RPI_CLI_COMPILER_USAGE_SUBCOMMAND=""
  local RPI_CLI_COMPILER_USAGE_SUBCOMMAND_ARGUMENTS=""
  local RPI_CLI_COMPILER_USAGE_SUBCOMMAND_HELP=""
  local RPI_CLI_COMPILER_USAGE_SUBCOMMAND_NAME=""

  RPI_CLI_COMPILER_GENERATED_CODE+="_${RPI_CLI_COMPILER_HEADER}_cli_usage() {\n"

  while IFS= read -r FILE_LINE; do
    case "${RPI_CLI_COMPILER_USAGE_LINE_INDEX}" in
      0)
        _cli_compiler_cli_function_usage_decorate_title
        ;;
      1)
        _cli_compiler_cli_function_usage_decorate_header
        ;;
      2)
        _cli_compiler_cli_function_usage_decorate_command_arguments
        ;;
      *)
        _cli_compiler_cli_function_usage_decorate_command_argument_list
        ;;
    esac

    RPI_CLI_COMPILER_GENERATED_CODE+="  echo -e \"${FILE_LINE}\"\n"
    ((RPI_CLI_COMPILER_USAGE_LINE_INDEX += 1))
  done <<< "${RPI_CLI_COMPILER_USAGE_STRING}"

  RPI_CLI_COMPILER_GENERATED_CODE+="}\n"
  RPI_CLI_COMPILER_GENERATED_CODE+="\n"
}

_cli_compiler_cli_function_usage_decorate_title() {
  FILE_LINE="$(_cli_pretty_title "${FILE_LINE}")"
}

_cli_compiler_cli_function_usage_decorate_header() {
  FILE_LINE="$(_cli_pretty_header "${FILE_LINE}")"
}

_cli_compiler_cli_function_usage_decorate_command_arguments() {
  FILE_LINE="$(_cli_pretty_brackets_style_2 "${FILE_LINE}")"
  FILE_LINE="  ${COLOUR_LIGHT_RED}${FILE_LINE}${COLOUR_NC}"
}

_cli_compiler_cli_function_usage_decorate_command_argument_list() {
  IFS="${RPI_CLI_COMPILER_FIELD_SEPERATOR}" read -r \
    RPI_CLI_COMPILER_USAGE_SUBCOMMAND \
    RPI_CLI_COMPILER_USAGE_SUBCOMMAND_HELP \
    <<< "${FILE_LINE}"

  # shellcheck disable=SC2034
  IFS=" " read -r \
    RPI_CLI_COMPILER_USAGE_SUBCOMMAND_NAME \
    RPI_CLI_COMPILER_USAGE_SUBCOMMAND_ARGUMENTS \
    <<< "${RPI_CLI_COMPILER_USAGE_SUBCOMMAND}"

  if [[ -n "${RPI_CLI_COMPILER_USAGE_SUBCOMMAND_HELP}" ]]; then
    _cli_compiler_cli_function_usage_decorate_command_argument_list_parameter
  else
    _cli_compiler_cli_function_usage_decorate_command_argument_list_switch
  fi
}

_cli_compiler_cli_function_usage_decorate_command_argument_list_parameter() {
  _cli_pretty_justify_left_var "${RPI_CLI_COLUMN_WIDTH}" "RPI_CLI_COMPILER_USAGE_SUBCOMMAND"
  RPI_CLI_COMPILER_USAGE_SUBCOMMAND="$(_cli_pretty_brackets_style_2 "${RPI_CLI_COMPILER_USAGE_SUBCOMMAND}")"
  RPI_CLI_COMPILER_USAGE_SUBCOMMAND="${COLOUR_LIGHT_BLUE}${RPI_CLI_COMPILER_USAGE_SUBCOMMAND}${COLOUR_NC}"
  RPI_CLI_COMPILER_USAGE_SUBCOMMAND_HELP="$(_cli_pretty_brackets_style_2 "${RPI_CLI_COMPILER_USAGE_SUBCOMMAND_HELP}")"
  FILE_LINE="    ${RPI_CLI_COMPILER_USAGE_SUBCOMMAND} - ${RPI_CLI_COMPILER_USAGE_SUBCOMMAND_HELP}"
}

_cli_compiler_cli_function_usage_decorate_command_argument_list_switch() {
  FILE_LINE="   ${COLOUR_LIGHT_BLUE}${RPI_CLI_COMPILER_USAGE_SUBCOMMAND:0:2}${COLOUR_NC} "
  FILE_LINE+="$(
    _cli_pretty_brackets_style_1 "${RPI_CLI_COMPILER_USAGE_SUBCOMMAND:3}" |
      _cli_pretty_justify_left "${RPI_CLI_COLUMN_WIDTH}"
  )"
}

_cli_compiler_cli_function_usage_error() {
  RPI_CLI_COMPILER_GENERATED_CODE+="_${RPI_CLI_COMPILER_HEADER}_cli_usage_error() {\n"
  RPI_CLI_COMPILER_GENERATED_CODE+="  {\n"
  RPI_CLI_COMPILER_GENERATED_CODE+="    _${RPI_CLI_COMPILER_HEADER}_cli_usage\n"
  RPI_CLI_COMPILER_GENERATED_CODE+="  } >&2\n"
  RPI_CLI_COMPILER_GENERATED_CODE+="  return 127\n"
  RPI_CLI_COMPILER_GENERATED_CODE+="}\n"
}

_cli_compiler_cli_process_generated_code() {
  # $1: the raw compiled bash code

  if _cli_compiler_query_is_compilation_memory_only; then
    eval "$(echo -e "${1}")"
  else
    echo -e "${1}" >> "${RPI_PATH_COMPILED_CLI}"
  fi
}

_cli_compiler_cli_write_file_header() {
  if ! _cli_compiler_query_is_compilation_memory_only; then
    {
      echo "#!/bin/bash"
      echo ""
      echo "# Automatically generated by pictl on $(date)"
      echo ""
    } > "${RPI_PATH_COMPILED_CLI}"
  fi
}
