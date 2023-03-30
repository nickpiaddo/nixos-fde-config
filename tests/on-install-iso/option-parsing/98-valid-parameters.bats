# Copyright (c) 2023 Nick Piaddo
# SPDX-License-Identifier: Apache-2.0 OR MIT

setup() {
  load "${TEST_DIR}/test_helper/bats-assert/load"
  load "${TEST_DIR}/test_helper/bats-file/load"
  load "${TEST_DIR}/test_helper/bats-support/load"
}

@test "Running nixos-fde-config with valid parameters succeeds" {
  run bash -c "${SSH} /root/nixos-fde-config -t \
    --main-disk /dev/sda \
    --boot-key /dev/sdb \
    --root-size 16G \
    --swap-size 4G \
    --home-size 8G"

  assert_success
}

@test "Running nixos-fde-config with valid parameters and no swap succeeds" {
  run expect -c \
    "spawn ${EXP_SSH} /root/nixos-fde-config -t \
    --main-disk /dev/sda \
    --boot-key /dev/sdb \
    --root-size 16G \
    --swap-size 0

    expect \"Would you like to continue? \[y/N] \"
    send -- \"y\r\"
    expect eof
    exit" 3>&-

  assert_line --partial "no space allocated for SWAP."
  assert_success
}

@test "Running nixos-fde-config with valid parameters and no home partition succeeds" {
  run expect -c \
    "spawn ${EXP_SSH} /root/nixos-fde-config -t \
    --main-disk /dev/sda \
    --boot-key /dev/sdb \
    --root-size 16G \
    --swap-size 4G \
    --home-size 0

    expect \"Would you like to continue? \[y/N] \"
    send -- \"y\r\"
    expect eof
    exit" 3>&-

  assert_line --partial "no space allocated for the home partition."
  assert_success
}

@test "Running nixos-fde-config with valid parameters, no swap, and no home partition succeeds" {
  run expect -c \
    "spawn ${EXP_SSH} /root/nixos-fde-config -t \
    --main-disk /dev/sda \
    --boot-key /dev/sdb \
    --root-size 16G \
    --swap-size 0 \
    --home-size 0

    expect \"Would you like to continue? \[y/N] \"
    send -- \"y\r\"
    expect \"Would you like to continue? \[y/N] \"
    send -- \"y\r\"
    expect eof
    exit" 3>&-

  assert_line --partial "no space allocated for SWAP."
  assert_line --partial "no space allocated for the home partition."

  assert_success
}

@test "Running nixos-fde-config with valid parameters + skip-wipe-disks succeeds" {
  run bash -c "${SSH} /root/nixos-fde-config -t \
    --main-disk /dev/sda \
    --boot-key /dev/sdb \
    --root-size 16G \
    --swap-size 4G \
    --home-size 8G \
    --skip-wipe-disks"

  assert_success
}
