# Copyright (c) 2023 Nick Piaddo
# SPDX-License-Identifier: Apache-2.0 OR MIT

setup() {
  load "${TEST_DIR}/test_helper/bats-assert/load"
  load "${TEST_DIR}/test_helper/bats-file/load"
  load "${TEST_DIR}/test_helper/bats-support/load"
}

@test "A  MISSING   short main-disk OPTION triggers an error" {
  run bash -c "${SSH} /root/nixos-fde-config -t -b /dev/sdb"

  assert_failure 1
  assert_line --partial "the option '-m, --main-disk' is required."
}

@test "A  MISSING   short main-disk option VALUE triggers an error" {
  run bash -c "${SSH} /root/nixos-fde-config -t -m"

  assert_failure 1
  assert_line --partial "option -m, --main-disk requires an argument."
}

@test "An INVALID   short main-disk option VALUE triggers an error" {
  run bash -c "${SSH} /root/nixos-fde-config -t -m /dev/null"

  assert_failure 1
  assert_line --partial "'/dev/null' is not a disk."
}

@test "A  REDEFINED short main-disk option with the SAME VALUE is ignored" {
  run bash -c "${SSH} /root/nixos-fde-config -t -m /dev/sda -b /dev/sdb -m /dev/sda"

  assert_success
}

@test "A  REDEFINED short main-disk option with CONFLICTING VALUES triggers an error" {
  run bash -c "${SSH} /root/nixos-fde-config -t -m /dev/sda -b /dev/sdb -m /dev/sdb"

  assert_failure 1
  assert_line --partial "redefined with conflicting values: '/dev/sda' vs '/dev/sdb'"
}

@test "A  MISSING long  main-disk OPTION triggers an error" {
  run bash -c "${SSH} /root/nixos-fde-config -t --boot-key /dev/sdb"

  assert_failure 1
  assert_line --partial "the option '-m, --main-disk' is required."
}

@test "A  MISSING   long  main-disk option VALUE triggers an error" {
  run bash -c "${SSH} /root/nixos-fde-config -t --main-disk"

  assert_failure 1
  assert_line --partial "option -m, --main-disk requires an argument."
}

@test "An INVALID   long  main-disk option VALUE triggers an error" {
  run bash -c "${SSH} /root/nixos-fde-config -t --main-disk /dev/null"

  assert_failure 1
  assert_line --partial "'/dev/null' is not a disk."
}

@test "A  REDEFINED long main-disk option with the SAME VALUE is ignored" {
  run bash -c "${SSH} /root/nixos-fde-config -t \
    --main-disk /dev/sda \
    --boot-key /dev/sdb \
    --main-disk /dev/sda"

  assert_success
}

@test "A  REDEFINED long main-disk option with CONFLICTING VALUES triggers an error" {
  run bash -c "${SSH} /root/nixos-fde-config -t \
    --main-disk /dev/sda \
    --boot-key /dev/sdb \
    --main-disk /dev/sdb"

  assert_failure 1
  assert_line --partial "redefined with conflicting values: '/dev/sda' vs '/dev/sdb'"
}

@test "An already mounted main disk triggers an error" {
  run bash -c "${SSH} /root/nixos-fde-config -t -m /dev/sr0"

  assert_failure 1
  assert_line --partial "'/dev/sr0' is currently mounted on mount point(s): /iso . Please unmount them all and start again."

  run bash -c "${SSH} /root/nixos-fde-config -t --main-disk /dev/sr0"

  assert_failure 1
  assert_line --partial "'/dev/sr0' is currently mounted on mount point(s): /iso . Please unmount them all and start again."
}

@test "A main disk with less than 16GiB triggers an error" {
  run bash -c "${SSH} /root/nixos-fde-config -t -m /dev/sdc"

  assert_failure 1
  assert_line --partial "'/dev/sdc' must have at least 16GiB available."

  run bash -c "${SSH} /root/nixos-fde-config -t --main-disk /dev/sdc"

  assert_failure 1
  assert_line --partial "'/dev/sdc' must have at least 16GiB available."
}
