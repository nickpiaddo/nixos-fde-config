# Copyright (c) 2023 Nick Piaddo
# SPDX-License-Identifier: Apache-2.0 OR MIT

setup() {
  load "${TEST_DIR}/test_helper/bats-assert/load"
  load "${TEST_DIR}/test_helper/bats-file/load"
  load "${TEST_DIR}/test_helper/bats-support/load"
}

@test "A  MISSING   short boot-key OPTION triggers an error" {
  run bash -c "${SSH} /root/nixos-fde-config -t -m /dev/sda"

  assert_failure 1
  assert_line --partial "the option '-b, --boot-key' is required."
}

@test "A  MISSING   short boot-key option VALUE triggers an error" {
  run bash -c "${SSH} /root/nixos-fde-config -t -b"

  assert_failure 1
  assert_line --partial "option -b, --boot-key requires an argument."
}

@test "An INVALID   short boot-key option VALUE triggers an error" {
  run bash -c "${SSH} /root/nixos-fde-config -t -b /dev/null"

  assert_failure 1
  assert_line --partial "'/dev/null' is not a disk."
}

@test "A  REDEFINED short boot-key option with the SAME VALUE is ignored" {
  run bash -c "${SSH} /root/nixos-fde-config -t -b /dev/sdb -m /dev/sda -R 16G -b /dev/sdb -S 4G -H 8G"

  assert_success
}

@test "A  REDEFINED short boot-key option with CONFLICTING VALUES triggers an error" {
  run bash -c "${SSH} /root/nixos-fde-config -t -b /dev/sda -m /dev/sda -R 16G -b /dev/sdb"

  assert_failure 1
  assert_line --partial "redefined with conflicting values: '/dev/sda' vs '/dev/sdb'"
}

@test "A  MISSING   long  boot-key OPTION triggers an error" {
  run bash -c "${SSH} /root/nixos-fde-config -t --main-disk /dev/sda"

  assert_failure 1
  assert_line --partial "the option '-b, --boot-key' is required."
}

@test "A  MISSING   long  boot-key option VALUE triggers an error" {
  run bash -c "${SSH} /root/nixos-fde-config -t --boot-key"

  assert_failure 1
  assert_line --partial "option -b, --boot-key requires an argument."
}

@test "An INVALID   long  boot-key option VALUE triggers an error" {
  run bash -c "${SSH} /root/nixos-fde-config -t --boot-key /dev/null"

  assert_failure 1
  assert_line --partial "'/dev/null' is not a disk."
}

@test "A  REDEFINED long boot-key option with the SAME VALUE is ignored" {
  run bash -c "${SSH} /root/nixos-fde-config -t \
    --boot-key /dev/sdb \
    --main-disk /dev/sda \
    --root-size 16G \
    --boot-key /dev/sdb \
    --swap-size 4G \
    --home-size 8G"

  assert_success
}

@test "A  REDEFINED long boot-key option with CONFLICTING VALUES triggers an error" {
  run bash -c "${SSH} /root/nixos-fde-config -t \
    --boot-key /dev/sda \
    --main-disk /dev/sda \
    --root-size 16G \
    --boot-key /dev/sdb"

  assert_failure 1
  assert_line --partial "redefined with conflicting values: '/dev/sda' vs '/dev/sdb'"
}

@test "A boot key MUST HAVE at least 2GiB of space available " {
  # Short option
  run bash -c "${SSH} /root/nixos-fde-config -t -b /dev/sdc"

  assert_failure 1
  assert_line --partial "'/dev/sdc' must have at least 2GiB available."

  # Long option
  run bash -c "${SSH} /root/nixos-fde-config -t --boot-key /dev/sdc"

  assert_failure 1
  assert_line --partial "'/dev/sdc' must have at least 2GiB available."
}

@test "Main-disk and boot-key option values MUST NOT point to the same device" {
  run bash -c "${SSH} /root/nixos-fde-config -t \
    --main-disk /dev/sda  --boot-key /dev/sda \
    --root-size 8G --swap-size 1G"

  assert_failure 1
  assert_line --partial "options main-disk and boot-key refer to the same device: /dev/sda"
}
