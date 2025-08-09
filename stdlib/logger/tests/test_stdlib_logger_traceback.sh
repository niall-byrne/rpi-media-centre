#!/bin/bash

# This test is unfortunately coupled to the test runner as FUNCNAME cannot be set.
test_stdlib_logger_traceback__mock_call_stack__generates_correct_stdout() {
  _capture.stdout_raw stdlib.logger.traceback

  assert_output "Callstack:
>  main
>>  _test_runner_main
>>>  _test_runner_execute
>>>>  source
>>>>>  run_test_suite
>>>>>>  run_tests
>>>>>>>  run_test
>>>>>>>>  test_stdlib_logger_traceback__mock_call_stack__generates_correct_stdout
"
}
