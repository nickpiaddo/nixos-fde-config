# Copyright (c) 2023 Nick Piaddo
# SPDX-License-Identifier: Apache-2.0 OR MIT

setup() {
  load "${TEST_DIR}/test_helper/bats-assert/load"
  load "${TEST_DIR}/test_helper/bats-file/load"
  load "${TEST_DIR}/test_helper/bats-support/load"
}

@test "Created 2GiB boot partition" {
  run bash -c "${SSH} lsblk --pairs --output SIZE /dev/sdb1"

  assert_success
  assert_line --partial "2G"
}

@test "Labelled  boot-key 'ESP'" {
  run bash -c "${SSH} lsblk --pairs --output LABEL /dev/sdb1"

  assert_success
  assert_line --partial "ESP"
}

@test "Formatted boot-key to FAT32" {
  run bash -c "${SSH} lsblk --pairs --output FSTYPE,FSVER /dev/sdb1"

  assert_success
  assert_line --partial "vfat"
  assert_line --partial "FAT32"
}
