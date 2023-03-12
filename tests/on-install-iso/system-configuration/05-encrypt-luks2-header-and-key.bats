# Copyright (c) 2023 Nick Piaddo
# SPDX-License-Identifier: Apache-2.0 OR MIT

setup() {
  load "${TEST_DIR}/test_helper/bats-assert/load"
  load "${TEST_DIR}/test_helper/bats-file/load"
  load "${TEST_DIR}/test_helper/bats-support/load"
}

@test "Created encrypted archive of LUKS2 header and key" {
  run bash -c "${SSH} head -n 2 /mnt/etc/nixos/initrd/secrets/secboot"

  assert_success
  assert_line --partial "age-encryption.org/v1"
  assert_line --partial "-> scrypt"
}

@test "Created copy of encrypted archive for system recovery" {
  run bash -c "${SSH} cmp /mnt/etc/nixos/initrd/secrets/secboot /mnt/boot/EFI/extended/secboot"
  assert_success
}
