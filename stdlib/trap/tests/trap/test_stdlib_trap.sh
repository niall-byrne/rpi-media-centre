#!/bin/bash

setup() {
  _mock.create stdlib.trap.create.clean_up_fn
  _mock.create stdlib.trap.create.handler
  _mock.create stdlib.trap.handler.err.fn.register
  _mock.create stdlib.trap.handler.exit.fn.register
}

test_stdlib_trap__traceback_enabled___sourced__trap_handlers_are_created() {
  STDLIB_TRACEBACK_DISABLE_BOOLEAN=0 _testing.load "${STDLIB_DIRECTORY}/trap/trap.sh" > /dev/null

  stdlib.trap.create.handler.mock.assert_calls_are \
    "1(stdlib.trap.handler.err.fn) 2(STDLIB_HANDLER_ERR)" \
    "1(stdlib.trap.handler.exit.fn) 2(STDLIB_HANDLER_EXIT)"
}

test_stdlib_trap__traceback_enabled___sourced__clean_up_fn_created() {
  STDLIB_TRACEBACK_DISABLE_BOOLEAN=0 _testing.load "${STDLIB_DIRECTORY}/trap/trap.sh" > /dev/null

  stdlib.trap.create.clean_up_fn "1(stdlib.trap.fn.clean_up_on_exit) 2(STDLIB_CLEANUP_FN)"
}

test_stdlib_trap__traceback_enabled___sourced__clean_up_fn_registered() {
  STDLIB_TRACEBACK_DISABLE_BOOLEAN=0 _testing.load "${STDLIB_DIRECTORY}/trap/trap.sh" > /dev/null

  stdlib.trap.handler.exit.fn.register.mock.assert_called_once_with "1(stdlib.trap.fn.clean_up_on_exit)"
}

test_stdlib_trap__traceback_enabled___sourced__stdlib_logger_traceback_is_registered() {
  STDLIB_TRACEBACK_DISABLE_BOOLEAN=0 _testing.load "${STDLIB_DIRECTORY}/trap/trap.sh" > /dev/null

  stdlib.trap.handler.err.fn.register.mock.assert_called_once_with "1(stdlib.logger.traceback)"
}

test_stdlib_trap__traceback_disabled__sourced__trap_handlers_are_created() {
  STDLIB_TRACEBACK_DISABLE_BOOLEAN=1 _testing.load "${STDLIB_DIRECTORY}/trap/trap.sh" > /dev/null

  stdlib.trap.create.handler.mock.assert_calls_are \
    "1(stdlib.trap.handler.err.fn) 2(STDLIB_HANDLER_ERR)" \
    "1(stdlib.trap.handler.exit.fn) 2(STDLIB_HANDLER_EXIT)"
}

test_stdlib_trap__traceback_disabled__sourced__clean_up_fn_created() {
  STDLIB_TRACEBACK_DISABLE_BOOLEAN=1 _testing.load "${STDLIB_DIRECTORY}/trap/trap.sh" > /dev/null

  stdlib.trap.create.clean_up_fn "1(stdlib.trap.fn.clean_up_on_exit) 2(STDLIB_CLEANUP_FN)"
}

test_stdlib_trap__traceback_disabled__sourced__clean_up_fn_registered() {
  STDLIB_TRACEBACK_DISABLE_BOOLEAN=1 _testing.load "${STDLIB_DIRECTORY}/trap/trap.sh" > /dev/null

  stdlib.trap.handler.exit.fn.register.mock.assert_called_once_with "1(stdlib.trap.fn.clean_up_on_exit)"
}

test_stdlib_trap__traceback_disabled__sourced__stdlib_logger_traceback_is_not_registered() {
  STDLIB_TRACEBACK_DISABLE_BOOLEAN=1 _testing.load "${STDLIB_DIRECTORY}/trap/trap.sh" > /dev/null

  stdlib.trap.handler.err.fn.register.mock.assert_not_called
}
