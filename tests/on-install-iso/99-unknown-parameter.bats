# Copyright (c) 2023 Nick Piaddo
# SPDX-License-Identifier: Apache-2.0 OR MIT

setup() {
  TEST_DIR="${BASE_DIR}/tests"
  load "${TEST_DIR}/test_helper/bats-assert/load"
  load "${TEST_DIR}/test_helper/bats-file/load"
  load "${TEST_DIR}/test_helper/bats-support/load"
}

@test "An UNKNOWN short parameter OPTION as the ONLY argument triggers an error" {
  run bash -c "${SSH} /root/nixos-fde-config -U"

  assert_line --partial "unknown option: -U"
  assert_failure 1
}

@test "An UNKNOWN long  parameter OPTION as the ONLY argument triggers an error" {
  run bash -c "${SSH} /root/nixos-fde-config --unknown"

  assert_line --partial "unknown option: --unknown"
  assert_failure 1
}
