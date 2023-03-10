# Copyright (c) 2023 Nick Piaddo
# SPDX-License-Identifier: Apache-2.0 OR MIT

setup() {
  TEST_DIR="${BASE_DIR}/tests"
  load "${TEST_DIR}/test_helper/bats-assert/load"
  load "${TEST_DIR}/test_helper/bats-file/load"
  load "${TEST_DIR}/test_helper/bats-support/load"
}

@test "Running nixos-fde-config -h prints help page" {
  run bash -c "${SSH} /root/nixos-fde-config -h"

  assert_line --partial "DESCRIPTION"
  assert_success
}

@test "Running nixos-fde-config --help prints help page" {
  run bash -c "${SSH} /root/nixos-fde-config --help"

  assert_line --partial "DESCRIPTION"
  assert_success
}
