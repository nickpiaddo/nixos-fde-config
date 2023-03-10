# Copyright (c) 2023 Nick Piaddo
# SPDX-License-Identifier: Apache-2.0 OR MIT

setup() {
  load "${TEST_DIR}/test_helper/bats-assert/load"
  load "${TEST_DIR}/test_helper/bats-file/load"
  load "${TEST_DIR}/test_helper/bats-support/load"
}

@test "Running nixos-fde-config with valid parameters succeeds" {
  run bash -c "${SSH} /root/nixos-fde-config -t \
    --main-disk /dev/sda"

  assert_success
}
