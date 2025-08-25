#!/bin/bash

_uppercase() {
  echo "UPPERCASE: ${1}" | tr '[:lower:]' '[:upper:]'
}
