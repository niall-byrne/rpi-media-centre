#!/bin/bash

# pictl backup job message library

set -eo pipefail

_backup_job_message_remote_param() {
  echo -e "${COLOUR_CYAN}Valid S3 Parameters:${COLOUR_NC}"
  echo -en "\t - ${COLOUR_LIGHT_BLUE}STANDARD${COLOUR_NC} "
  _cli_pretty_brackets_style_1 "${COLOUR_GRAY}" "${COLOUR_WHITE}" "(default value)"
  echo -e "\t - ${COLOUR_LIGHT_BLUE}REDUCED_REDUNDANCY${COLOUR_NC}"
  echo -e "\t - ${COLOUR_LIGHT_BLUE}STANDARD_IA${COLOUR_NC}"
  echo -e "\t - ${COLOUR_LIGHT_BLUE}ONEZONE_IA${COLOUR_NC}"
  echo -e "\t - ${COLOUR_LIGHT_BLUE}INTELLIGENT_TIERING${COLOUR_NC}"
  echo -e "\t - ${COLOUR_LIGHT_BLUE}GLACIER${COLOUR_NC}"
  echo -e "\t - ${COLOUR_LIGHT_BLUE}DEEP_ARCHIVE${COLOUR_NC}"
  echo -e "\t - ${COLOUR_LIGHT_BLUE}GLACIER_IR${COLOUR_NC}"
  echo -e "  *Please see https://aws.amazon.com/s3/storage-classes for details."
}

_backup_job_message_queue() {
  _cli_pretty_header "Valid Queues:"
  echo -e "\t $(printf "%-32s" "- ${COLOUR_LIGHT_BLUE}rsync${COLOUR_NC}")- create rsync copy"
  echo -e "\t $(printf "%-32s" "- ${COLOUR_LIGHT_BLUE}tar${COLOUR_NC}")- create tar bundle"
  echo -e "\t $(printf "%-32s" "- ${COLOUR_LIGHT_BLUE}upload${COLOUR_NC}")- upload tar bundle to remote storage"
}

_backup_job_message_remote_target() {
  _cli_pretty_header "Valid Remote Targets:"
  echo -e "\t - ${COLOUR_LIGHT_BLUE}s3:${COLOUR_NC}//${COLOUR_GRAY}bucket_name${COLOUR_NC}/${COLOUR_GRAY}path_name${COLOUR_NC}"
}

_backup_job_message_tarball_versions() {
  _cli_pretty_header "Valid Version Count:"
  _cli_pretty_numbers "\t - any number between 1 and 9 "
  _cli_pretty_brackets_style_1 "${COLOUR_GRAY}" "${COLOUR_WHITE}" "(inclusive)"
}
