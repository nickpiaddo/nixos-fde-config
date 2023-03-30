# Copyright (c) 2023 Nick Piaddo
# SPDX-License-Identifier: Apache-2.0 OR MIT

setup() {
  load "${TEST_DIR}/test_helper/bats-assert/load"
  load "${TEST_DIR}/test_helper/bats-file/load"
  load "${TEST_DIR}/test_helper/bats-support/load"
}

@test "Requesting more partition space than total available triggers an error" {
  # Total main disk size 32GiB
  #  Requesting 36GiB + 16MiB for metadata
  run bash -c "${SSH} /root/nixos-fde-config -t \
    --main-disk /dev/sda \
    --boot-key /dev/sdb \
    --root-size 16G \
    --swap-size 4G \
    --home-size 16G"

  assert_failure 1
  assert_line --partial "Need at least 36.01GiB, but has only 32GiB available."
}
