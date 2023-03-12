# Copyright (c) 2023 Nick Piaddo
# SPDX-License-Identifier: Apache-2.0 OR MIT

setup() {
  load "${TEST_DIR}/test_helper/bats-assert/load"
  load "${TEST_DIR}/test_helper/bats-file/load"
  load "${TEST_DIR}/test_helper/bats-support/load"
}

@test "Created a LUKS2 header file" {
  run bash -c "${SSH} nix-shell --run \'file /root/secrets/luks-header\' --packages file"

  assert_success
  assert_line --partial "LUKS encrypted file, ver 2"
}

@test "Created a LUKS2 key file" {
  run bash -c "${SSH} test -f /root/secrets/luks-keyfile"

  assert_success
}

@test "Created a LUKS2 container" {
  run bash -c "${SSH} lsblk --pairs --output TYPE /dev/mapper/lukscontainer"

  assert_success
  assert_line --partial "crypt"
}

@test "Created 16GiB LVM root partition" {
  run bash -c "${SSH} lsblk --pairs --output SIZE,TYPE /dev/mapper/vg_nixos-root"

  assert_success
  assert_line --partial "16G"
  assert_line --partial "lvm"
}

@test "Created  4GiB LVM swap partition" {
  run bash -c "${SSH} lsblk --pairs --output SIZE,TYPE /dev/mapper/vg_nixos-swap"

  assert_success
  assert_line --partial "4G"
  assert_line --partial "lvm"
}

@test "Created 10GiB LVM home partition" {
  run bash -c "${SSH} lsblk --pairs --output SIZE,TYPE /dev/mapper/vg_nixos-home"

  assert_success
  assert_line --partial "10G"
  assert_line --partial "lvm"
}

@test "Labelled root partition 'root'" {
  run bash -c "${SSH} lsblk --pairs --output LABEL /dev/mapper/vg_nixos-root"

  assert_success
  assert_line --partial "root"
}

@test "Labelled swap partition 'swap'" {
  run bash -c "${SSH} lsblk --pairs --output LABEL /dev/mapper/vg_nixos-swap"

  assert_success
  assert_line --partial "swap"
}

@test "Labelled home partition 'home'" {
  run bash -c "${SSH} lsblk --pairs --output LABEL /dev/mapper/vg_nixos-home"

  assert_success
  assert_line --partial "home"
}

@test "Formatted root partition to ext4" {
  run bash -c "${SSH} lsblk --pairs --output FSTYPE /dev/mapper/vg_nixos-root"

  assert_success
  assert_line --partial "ext4"
}

@test "Formatted swap partition to swap" {
  run bash -c "${SSH} lsblk --pairs --output FSTYPE /dev/mapper/vg_nixos-swap"

  assert_success
  assert_line --partial "swap"
}

@test "Formatted home partition to ext4" {
  run bash -c "${SSH} lsblk --pairs --output FSTYPE /dev/mapper/vg_nixos-home"

  assert_success
  assert_line --partial "ext4"
}
