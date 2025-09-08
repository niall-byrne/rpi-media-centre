#!/bin/bash

setup() {
  _mock.create _debug_with
  _mock.create stdlib.trap.handler.exit.fn.register
}

test_trap__sourced__registers_debug_handler() {
  _testing.load "${RPI_WORKING_DIRECTORY}/lib/trap.sh" > /dev/null

  _debug_with.mock.assert_called_once_with \
    "1(stdlib.trap.handler.err.fn.register) 2(_debug_error_handler)"
}

test_trap__sourced__registers_cleanup_handler() {
  _testing.load "${RPI_WORKING_DIRECTORY}/lib/trap.sh" > /dev/null

  stdlib.trap.handler.exit.fn.register.mock.assert_called_once_with \
    "1(_trap_cleanup)"
}
