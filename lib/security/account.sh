#!/bin/bash

# pictl security accounts library

set -eo pipefail

# TODO: you need to re-template the cron and service files when you change users
# TODO: move the account command under a "installer cli"

_security_account_provision_service_account() {

  if [[ -z "${RPI_SVC_USERNAME}" ]] ||
    [[ "${RPI_SVC_USERNAME}" == "${SUDO_USER}" ]]; then
    _cli_log_error "SECURITY: You must specify the RPI_SVC_USERNAME to provision a service account."
    return 127
  fi

  if [[ -z "${RPI_SVC_GROUPNAME}" ]]; then
    if ! getent passwd "${RPI_SVC_USERNAME}" > /dev/null; then
      # If it's a new user, with no specified group, use the username
      RPI_SVC_GROUPNAME="${RPI_SVC_USERNAME}"
    else
      # Otherwise, fallback to the RPI_SVC_USERNAME's primary group
      RPI_SVC_GROUPNAME="$(id -gn "${RPI_SVC_USERNAME}")"
    fi
  fi

  _security_account_provision_service_account_group "${RPI_SVC_GROUPNAME}"
  _security_account_provision_service_account_username "${RPI_SVC_USERNAME}"

  _cli_log_success "SECURITY: The service account has been successfully provisioned."
  _cli_log_info "If this is the service account you wish to use it must be able to read your media file."
  _cli_log_info "Please consider: sudo chown -R ${RPI_SVC_USERNAME}:${RPI_SVC_GROUPNAME} ${RPI_ROOT}/shared/media"
}

_security_account_provision_service_account_group() {
  # $1: the group to create

  if ! getent group "${1}" > /dev/null; then
    _cli_log_warning "SECURITY: Adding the service account group '${1}' ..."

    _io_prompt_confirmation

    if [[ -n "${RPI_SVC_GID}" ]]; then
      groupadd \
        -g "${RPI_SVC_GID}" \
        -r \
        "${1}"
    else
      groupadd \
        -r \
        "${1}"
    fi

    _security_defaults_set_gid
    _cli_log_success "SECURITY: The service account group '${1}' has been created with gid '${RPI_SVC_GID}' !"

  else
    _cli_log_notice "SECURITY: The group '${1}' already exists, nothing to do."
    _security_defaults_set_gid
  fi
}

_security_account_provision_service_account_username() {
  # $1: the user to create

  if ! getent passwd "${1}" > /dev/null; then
    _cli_log_warning "SECURITY: Adding the service account user '${1}' ..."

    _io_prompt_confirmation

    if [[ -n "${RPI_SVC_UID}" ]]; then
      useradd \
        -u "${RPI_SVC_UID}" \
        -g "${RPI_SVC_GID}" \
        -r \
        -s /usr/sbin/nologin \
        -o \
        "${1}"
    else
      useradd \
        -g "${RPI_SVC_GID}" \
        -r \
        -s /usr/sbin/nologin \
        "${1}"
    fi

    _security_defaults_set_uid
    _cli_log_success "SECURITY: The service account user '${1}' has been created with uid '${RPI_SVC_UID}' !"

  else
    _cli_log_notice "SECURITY: The user '${1}' already exists, nothing to do."
    _security_defaults_set_uid
  fi
}
