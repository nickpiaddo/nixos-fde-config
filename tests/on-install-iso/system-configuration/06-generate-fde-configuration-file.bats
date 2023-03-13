# Copyright (c) 2023 Nick Piaddo
# SPDX-License-Identifier: Apache-2.0 OR MIT

setup() {
  load "${TEST_DIR}/test_helper/bats-assert/load"
  load "${TEST_DIR}/test_helper/bats-file/load"
  load "${TEST_DIR}/test_helper/bats-support/load"
}

@test "Created FDE configuration file" {
  REGEX_BOOTKEY_ID="(([a-z]{2,3})-([a-zA-Z0-9_-]+)(-[0-9]:[0-9])?(-part[0-9]+)?)"

  run bash -c "${SSH} head -n 25 /mnt/etc/nixos/fde-configuration.nix"

  assert_success
  assert_regex "${REGEX_BOOTKEY_ID}"
  assert_line --partial "label = \"primary\";"
}
