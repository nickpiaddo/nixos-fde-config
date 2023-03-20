# Copyright (c) 2023 Nick Piaddo
# SPDX-License-Identifier: Apache-2.0 OR MIT

setup() {
  TEST_DIR="${BASE_DIR}/test"
  load "${TEST_DIR}/test_helper/bats-assert/load"
  load "${TEST_DIR}/test_helper/bats-file/load"
  load "${TEST_DIR}/test_helper/bats-support/load"
}

@test "Running script without parameters prints usage" {
  run bash -c "${SSH} /root/nixos-fde-config"

  assert_line --partial "nixos-fde-config --help"
  assert_failure 1
}
