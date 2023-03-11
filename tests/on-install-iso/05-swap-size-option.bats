# Copyright (c) 2023 Nick Piaddo
# SPDX-License-Identifier: Apache-2.0 OR MIT

setup() {
  load "${TEST_DIR}/test_helper/bats-assert/load"
  load "${TEST_DIR}/test_helper/bats-file/load"
  load "${TEST_DIR}/test_helper/bats-support/load"
}

@test "A  MISSING   short swap-size OPTION triggers an error" {
  run bash -c "${SSH} /root/nixos-fde-config -t -m /dev/sda -b /dev/sdb -R 8G"

  assert_failure 1
  assert_line --partial "the option '-S, --swap-size' is required."
}

@test "A  MISSING   short swap-size option VALUE triggers an error" {
  run bash -c "${SSH} /root/nixos-fde-config -t -S"

  assert_failure 1
  assert_line --partial "option -S, --swap-size requires an argument."
}

@test "An INVALID   short swap-size option VALUE triggers an error" {
  run bash -c "${SSH} /root/nixos-fde-config -t -S one_GiB"

  assert_failure 1
  assert_line --partial "Specified invalid partition size: one_GiB."
}

@test "A  REDEFINED short swap-size option with the SAME VALUE is ignored" {
  run bash -c "${SSH} /root/nixos-fde-config -t -S 4G -m /dev/sda -b /dev/sdb -R 8G -S 4G"

  assert_success
}

@test "A  REDEFINED short swap-size option with CONFLICTING VALUES triggers an error" {
  run bash -c "${SSH} /root/nixos-fde-config -t -S 4G -m /dev/sda -b /dev/sdb -R 8G -S 8G"

  assert_failure 1
  assert_line --partial "redefined with conflicting values: '4G' vs '8G'"
}

@test "A  MISSING   long  swap-size OPTION triggers an error" {
  run bash -c "${SSH} /root/nixos-fde-config -t \
    --main-disk /dev/sda \
    --boot-key /dev/sdb \
    --root-size 8G"

  assert_failure 1
  assert_line --partial "the option '-S, --swap-size' is required."
}

@test "A  MISSING   long  swap-size option VALUE triggers an error" {
  run bash -c "${SSH} /root/nixos-fde-config -t \
    --swap-size"

  assert_failure 1
  assert_line --partial "option -S, --swap-size requires an argument."
}

@test "An INVALID   long  swap-size option VALUE triggers an error" {
  run bash -c "${SSH} /root/nixos-fde-config -t \
    --swap-size one_GiB"

  assert_failure 1
  assert_line --partial "Specified invalid partition size: one_GiB."
}

@test "A  REDEFINED long swap-size option with the SAME VALUE is ignored" {
  run bash -c "${SSH} /root/nixos-fde-config -t \
    --swap-size 4G \
    --main-disk /dev/sda \
    --boot-key /dev/sdb \
    --root-size 16G \
    --swap-size 4G"

  assert_success
}

@test "A  REDEFINED long swap-size option with CONFLICTING VALUES triggers an error" {
  run bash -c "${SSH} /root/nixos-fde-config -t \
    --swap-size 4G \
    --main-disk /dev/sda \
    --boot-key /dev/sdb \
    --root-size 16G \
    --swap-size 8G"

  assert_failure 1
  assert_line --partial "redefined with conflicting values: '4G' vs '8G'"
}

@test "A swap partition size MUST BE either 0 or at least 4MiB" {
  run bash -c "${SSH} /root/nixos-fde-config -t -S 1M"

  assert_failure 1
  assert_line --partial "Swap size must be either 0 or at least 4MiB."

  run bash -c "${SSH} /root/nixos-fde-config -t --swap-size 1M"

  assert_failure 1
  assert_line --partial "Swap size must be either 0 or at least 4MiB."
}

@test "Ask for confirmation if swap-size set to zero" {
  run expect -c \
    "spawn  ${EXP_SSH} /root/nixos-fde-config -t -m /dev/sda -b /dev/sdb -R 8G -S 0
      expect \"Would you like to continue? \[y/N] \"
      send -- \"n\r\"
      expect eof
      exit" 3>&-

  assert_success
  assert_line --partial "no space allocated for SWAP."
}
