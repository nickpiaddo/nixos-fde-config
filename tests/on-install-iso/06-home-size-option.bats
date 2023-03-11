# Copyright (c) 2023 Nick Piaddo
# SPDX-License-Identifier: Apache-2.0 OR MIT

setup() {
  load "${TEST_DIR}/test_helper/bats-assert/load"
  load "${TEST_DIR}/test_helper/bats-file/load"
  load "${TEST_DIR}/test_helper/bats-support/load"
}

@test "A  MISSING   short home-size option VALUE triggers an error" {
  run bash -c "${SSH} /root/nixos-fde-config -t -H"

  assert_failure 1
  assert_line --partial "option -H, --home-size requires an argument."
}

@test "An INVALID   short home-size option VALUE triggers an error" {
  run bash -c "${SSH} /root/nixos-fde-config -t -H one_GiB"

  assert_failure 1
  assert_line --partial "Specified invalid partition size: one_GiB."
}

@test "A  REDEFINED short home-size option with the SAME VALUE is ignored" {
  run bash -c "${SSH} /root/nixos-fde-config -t -H 8G -m /dev/sda -b /dev/sdb -R 8G -S 4G -H 8G"

  assert_success
}

@test "A  REDEFINED short home-size option with CONFLICTING VALUES triggers an error" {
  run bash -c "${SSH} /root/nixos-fde-config -t -H 4G -m /dev/sda -b /dev/sdb -R 8G -S 4G -H 8G"

  assert_failure 1
  assert_line --partial "redefined with conflicting values: '4G' vs '8G'"
}

@test "A  MISSING   long  home-size option VALUE triggers an error" {
  run bash -c "${SSH} /root/nixos-fde-config -t --home-size"

  assert_failure 1
  assert_line --partial "option -H, --home-size requires an argument."
}

@test "An INVALID   long  home-size option VALUE triggers an error" {
  run bash -c "${SSH} /root/nixos-fde-config -t --home-size one_GiB"

  assert_failure 1
  assert_line --partial "Specified invalid partition size: one_GiB."
}

@test "A  REDEFINED long home-size option with the SAME VALUE is ignored" {
  run bash -c "${SSH} /root/nixos-fde-config -t \
    --home-size 8G \
    --main-disk /dev/sda \
    --boot-key /dev/sdb \
    --root-size 16G \
    --swap-size 4G \
    --home-size 8G"

  assert_success
}

@test "A  REDEFINED long home-size option with CONFLICTING VALUES triggers an error" {
  run bash -c "${SSH} /root/nixos-fde-config -t \
    --home-size 4G \
    --main-disk /dev/sda \
    --boot-key /dev/sdb \
    --root-size 16G \
    --swap-size 4G \
    --home-size 8G"

  assert_failure 1
  assert_line --partial "redefined with conflicting values: '4G' vs '8G'"
}

@test "A home partition size MUST BE either 0 or at least 4MiB" {
  run bash -c "${SSH} /root/nixos-fde-config -t -H 1M"

  assert_line --partial "Home partition size must be either 0 or at least 4MiB."
  assert_failure 1

  run bash -c "${SSH} /root/nixos-fde-config -t --home-size 1M"

  assert_failure 1
  assert_line --partial "Home partition size must be either 0 or at least 4MiB."
}

@test "Remaining free space, for default home-size, MUST BE either 0 or at least 4MiB" {
  # Provisioning root partition with 31GiB - 19MiB (includes 16MiB for metadata).
  # Only 3MiB available for home partition.
  run bash -c "${SSH} /root/nixos-fde-config -t \
    --main-disk /dev/sda \
    --boot-key /dev/sdb \
    --root-size 33266073600 \
    --swap-size 1G"

  assert_failure 1
  assert_line --partial "there is only 3MiB available. Home partition size must be either 0 or at least 4MiB."
}

@test "Ask for confirmation if home-size set to zero" {
  run expect -c \
    "spawn  ${EXP_SSH} /root/nixos-fde-config -t -m /dev/sda -b /dev/sdb -R 8G -S 1G -H 0
      expect \"Would you like to continue? \[y/N] \"
      send -- \"n\r\"
      expect eof
      exit" 3>&-

  assert_success
  assert_line --partial "no space allocated for the home partition."
}

@test "Ask for confirmation to allocate remaining disk space to home partition" {
  run expect -c \
    "spawn  ${EXP_SSH} /root/nixos-fde-config -t -m /dev/sda -b /dev/sdb -R 8G -S 1G
      expect \" \[y/N] \"
      send -- \"y\r\"
      expect eof
      exit" 3>&-

  assert_success
  assert_line --partial "Would you like to allocate the remaining"
}
