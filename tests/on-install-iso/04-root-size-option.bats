# Copyright (c) 2023 Nick Piaddo
# SPDX-License-Identifier: Apache-2.0 OR MIT

setup() {
  load "${TEST_DIR}/test_helper/bats-assert/load"
  load "${TEST_DIR}/test_helper/bats-file/load"
  load "${TEST_DIR}/test_helper/bats-support/load"
}

@test "A  MISSING   short root-size OPTION triggers an error" {
  run bash -c "${SSH} /root/nixos-fde-config -t -m /dev/sda -b /dev/sdb"

  assert_failure 1
  assert_line --partial "the option '-R, --root-size' is required."
}

@test "A  MISSING   short root-size option VALUE triggers an error" {
  run bash -c "${SSH} /root/nixos-fde-config -t -R"

  assert_failure 1
  assert_line --partial "option -R, --root-size requires an argument."
}

@test "An INVALID   short root-size option VALUE triggers an error" {
  run bash -c "${SSH} /root/nixos-fde-config -t -R one_GiB"

  assert_failure 1
  assert_line --partial "Specified invalid partition size: one_GiB."
}

@test "A  REDEFINED short root-size option with the SAME VALUE is ignored" {
  run bash -c "${SSH} /root/nixos-fde-config -t -R 16G -m /dev/sda -b /dev/sdb -R 16G -S 4G -H 8G"

  assert_success
}

@test "A  REDEFINED short root-size option with CONFLICTING VALUES triggers an error" {
  run bash -c "${SSH} /root/nixos-fde-config -t -R 16G -m /dev/sda -b /dev/sdb -R 20G"

  assert_failure 1
  assert_line --partial "redefined with conflicting values: '16G' vs '20G'"
}

@test "A  MISSING   long  root-size OPTION triggers an error" {
  run bash -c "${SSH} /root/nixos-fde-config -t \
    --main-disk /dev/sda \
    --boot-key /dev/sdb"

  assert_failure 1
  assert_line --partial "the option '-R, --root-size' is required."
}

@test "A  MISSING   long  root-size option VALUE triggers an error" {
  run bash -c "${SSH} /root/nixos-fde-config -t  --root-size"

  assert_failure 1
  assert_line --partial "option -R, --root-size requires an argument."
}

@test "An INVALID   long  root-size option VALUE triggers an error" {
  run bash -c "${SSH} /root/nixos-fde-config -t  --root-size one_GiB"

  assert_failure 1
  assert_line --partial "Specified invalid partition size: one_GiB."
}

@test "A  REDEFINED long root-size option with the SAME VALUE is ignored" {
  run bash -c "${SSH} /root/nixos-fde-config -t \
    --root-size 16G \
    --main-disk /dev/sda \
    --boot-key /dev/sdb \
    --root-size 16G \
    --swap-size 4G \
    --home-size 8G"

  assert_success
}

@test "A  REDEFINED long root-size option with CONFLICTING VALUES triggers an error" {
  run bash -c "${SSH} /root/nixos-fde-config -t \
    --root-size 16G \
    --main-disk /dev/sda \
    --boot-key /dev/sdb \
    --root-size 20G"

  assert_failure 1
  assert_line --partial "redefined with conflicting values: '16G' vs '20G'"
}

@test "A root partition MUST HAVE at least 8GiB available " {
  run bash -c "${SSH} /root/nixos-fde-config -t -R 1G"

  assert_failure 1
  assert_line --partial "A root partition must have at least 8GiB available. Please allocate more space."

  run bash -c "${SSH} /root/nixos-fde-config -t --root-size 1G"

  assert_failure 1
  assert_line --partial "A root partition must have at least 8GiB available. Please allocate more space."
}
