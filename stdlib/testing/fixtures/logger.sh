#!/bin/bash

# stdlib logger test fixtures

set -eo pipefail

_fixture_mock_stdlib_logger() {
  _mock.create stdlib.logger.error
  _mock.create stdlib.logger.warning
  _mock.create stdlib.logger.info
  _mock.create stdlib.logger.notice
  _mock.create stdlib.logger.success
}
