#!/bin/bash

# stdlib testing logger fixtures

builtin set -eo pipefail

_testing.fixtures.mock.logger() {
  _mock.create stdlib.logger.error
  _mock.create stdlib.logger.warning
  _mock.create stdlib.logger.info
  _mock.create stdlib.logger.notice
  _mock.create stdlib.logger.success
}
