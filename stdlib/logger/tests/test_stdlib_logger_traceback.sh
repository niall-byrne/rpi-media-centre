#!/bin/bash

# This test is unfortunately coupled to the test runner as FUNCNAME cannot be set.
test_stdlib_logger_traceback__mock_call_stack__generates_correct_stdout() {
  _capture.stdout_raw stdlib.logger.traceback

  assert_matches "Callstack:
>  /rpi-media-centre/testing/t:[0-9]+:main\(\)
>>  /rpi-media-centre/testing/t:[0-9]+:_test_runner_main\(\)
>>>  /rpi-media-centre/testing/t:[0-9]+:_test_runner_execute\(\)
>>>>  /usr/local/bin/bash_unit:[0-9]+:source\(\)
>>>>>  /usr/local/bin/bash_unit:[0-9]+:run_test_suite\(\)
>>>>>>  /usr/local/bin/bash_unit:[0-9]+:run_tests\(\)
>>>>>>>  /usr/local/bin/bash_unit:[0-9]+:run_test\(\)
>>>>>>>>  test_stdlib_logger_traceback.sh:[0-9]+:test_stdlib_logger_traceback__mock_call_stack__generates_correct_stdout\(\)
" \
    "${TEST_OUTPUT}"
}
