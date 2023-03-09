# Copyright (c) 2023 Nick Piaddo
# SPDX-License-Identifier: Apache-2.0 OR MIT

setup() {
  TEST_DIR="${BASE_DIR}/tests"
  load "${TEST_DIR}/test_helper/bats-assert/load"
  load "${TEST_DIR}/test_helper/bats-file/load"
  load "${TEST_DIR}/test_helper/bats-support/load"
}

@test "Running script with valid parameters succeeds" {
  assert [ 0 -eq 0 ]
}
