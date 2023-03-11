# Copyright (c) 2023 Nick Piaddo
# SPDX-License-Identifier: Apache-2.0 OR MIT

setup() {
  load "${TEST_DIR}/test_helper/bats-assert/load"
  load "${TEST_DIR}/test_helper/bats-file/load"
  load "${TEST_DIR}/test_helper/bats-support/load"
}

@test "Required tools installed" {
  # List installed packages
  run bash -c "${SSH} nix-env -q"

  assert_success
  assert_line --partial "age"
  assert_line --partial "b3sum"
  assert_line --partial "pv"
}
