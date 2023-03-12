# Copyright (c) 2023 Nick Piaddo
# SPDX-License-Identifier: Apache-2.0 OR MIT

setup() {
  load "${TEST_DIR}/test_helper/bats-assert/load"
  load "${TEST_DIR}/test_helper/bats-file/load"
  load "${TEST_DIR}/test_helper/bats-support/load"
}

@test "Mounted boot-key" {
  run bash -c "${SSH} lsblk --pairs --output MOUNTPOINTS /dev/sdb1"

  assert_success
  assert_line --partial "/mnt/boot"
}

@test "Mounted root partition" {
  run bash -c "${SSH} lsblk --pairs --output MOUNTPOINTS /dev/mapper/vg_nixos-root"

  assert_success
  assert_line --partial "/mnt"
}

@test "Mounted swap partition" {
  run bash -c "${SSH} lsblk --pairs --output MOUNTPOINTS /dev/mapper/vg_nixos-swap"

  assert_success
  assert_line --partial "[SWAP]"
}

@test "Mounted home partition" {
  run bash -c "${SSH} lsblk --pairs --output MOUNTPOINTS /dev/mapper/vg_nixos-home"

  assert_success
  assert_line --partial "/mnt/home"
}
