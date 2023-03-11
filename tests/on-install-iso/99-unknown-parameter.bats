# Copyright (c) 2023 Nick Piaddo
# SPDX-License-Identifier: Apache-2.0 OR MIT

setup() {
  load "${TEST_DIR}/test_helper/bats-assert/load"
  load "${TEST_DIR}/test_helper/bats-file/load"
  load "${TEST_DIR}/test_helper/bats-support/load"
}

@test "An UNKNOWN short parameter OPTION as the ONLY argument triggers an error" {
  run bash -c "${SSH} /root/nixos-fde-config -U"

  assert_line --partial "unknown option: -U"
  assert_failure 1
}

@test "An UNKNOWN short parameter OPTION as the FIRST argument triggers an error" {
  run bash -c "${SSH} /root/nixos-fde-config -U -h"

  assert_line --partial "unknown option: -U"
  assert_failure 1

  run bash -c "${SSH} /root/nixos-fde-config -U -m /dev/sda"

  assert_line --partial "unknown option: -U"
  assert_failure 1
}

@test "An UNKNOWN short parameter OPTION as the SECOND argument triggers an error" {
  run bash -c "${SSH} /root/nixos-fde-config -m /dev/sda -U -b /dev/sdb"

  assert_line --partial "unknown option: -U"
  assert_failure 1
}

@test "An UNKNOWN short parameter OPTION as the THIRD argument triggers an error" {
  run bash -c "${SSH} /root/nixos-fde-config -m /dev/sda -b /dev/sdb -U -R 8G"

  assert_line --partial "unknown option: -U"
  assert_failure 1
}

@test "An UNKNOWN short parameter OPTION as the LAST argument triggers an error" {
  run bash -c "${SSH} /root/nixos-fde-config -m /dev/sda -b /dev/sdb -R 8G -U"

  assert_line --partial "unknown option: -U"
  assert_failure 1
}

@test "An UNKNOWN long  parameter OPTION as the ONLY argument triggers an error" {
  run bash -c "${SSH} /root/nixos-fde-config --unknown"

  assert_line --partial "unknown option: --unknown"
  assert_failure 1
}

@test "An UNKNOWN long  parameter OPTION as the FIRST argument triggers an error" {
  run bash -c "${SSH} /root/nixos-fde-config --unknown --help"

  assert_line --partial "unknown option: --unknown"
  assert_failure 1

  run bash -c "${SSH} /root/nixos-fde-config --unknown --main-disk /dev/sda"

  assert_line --partial "unknown option: --unknown"
  assert_failure 1
}

@test "An UNKNOWN long  parameter OPTION as the SECOND argument triggers an error" {
  run bash -c "${SSH} /root/nixos-fde-config \
    --main-disk /dev/sda \
    --unknown \
    --boot-key /dev/sdb"

  assert_line --partial "unknown option: --unknown"
  assert_failure 1
}

@test "An UNKNOWN long  parameter OPTION as the THIRD argument triggers an error" {
  run bash -c "${SSH} /root/nixos-fde-config \
    --main-disk /dev/sda \
    --boot-key /dev/sdb \
    --unknown \
    --root-size 8G"

  assert_line --partial "unknown option: --unknown"
  assert_failure 1
}

@test "An UNKNOWN long  parameter OPTION as the LAST argument triggers an error" {
  run bash -c "${SSH} /root/nixos-fde-config \
    --main-disk /dev/sda \
    --boot-key /dev/sdb \
    --root-size 8G \
    --unknown"

  assert_line --partial "unknown option: --unknown"
  assert_failure 1
}
