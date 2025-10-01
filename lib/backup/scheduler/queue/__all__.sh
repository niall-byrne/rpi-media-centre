#!/bin/bash

set -eo pipefail

# shellcheck source=lib/backup/scheduler/queue/dequeue.sh
source "${RPI_WORKING_DIRECTORY}/lib/backup/scheduler/queue/dequeue.sh"
# shellcheck source=lib/backup/scheduler/queue/enqueue.sh
source "${RPI_WORKING_DIRECTORY}/lib/backup/scheduler/queue/enqueue.sh"
# shellcheck source=lib/backup/scheduler/queue/forward.sh
source "${RPI_WORKING_DIRECTORY}/lib/backup/scheduler/queue/forward.sh"
# shellcheck source=lib/backup/scheduler/queue/make.sh
source "${RPI_WORKING_DIRECTORY}/lib/backup/scheduler/queue/make.sh"
# shellcheck source=lib/backup/scheduler/queue/remove.sh
source "${RPI_WORKING_DIRECTORY}/lib/backup/scheduler/queue/remove.sh"
# shellcheck source=lib/backup/scheduler/queue/show.sh
source "${RPI_WORKING_DIRECTORY}/lib/backup/scheduler/queue/show.sh"
