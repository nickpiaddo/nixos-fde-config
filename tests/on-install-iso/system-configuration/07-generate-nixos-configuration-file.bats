# Copyright (c) 2023 Nick Piaddo
# SPDX-License-Identifier: Apache-2.0 OR MIT

setup() {
  load "${TEST_DIR}/test_helper/bats-assert/load"
  load "${TEST_DIR}/test_helper/bats-file/load"
  load "${TEST_DIR}/test_helper/bats-support/load"
}

@test "Created NixOS configuration file" {
  run bash -c "${SSH} head -n 25 /mnt/etc/nixos/configuration.nix"

  assert_line --partial "fde-configuration.nix"
  assert_success
}
