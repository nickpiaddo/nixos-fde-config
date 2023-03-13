# Copyright (c) 2023 Nick Piaddo
# SPDX-License-Identifier: Apache-2.0 OR MIT

setup() {
  load "${TEST_DIR}/test_helper/bats-assert/load"
  load "${TEST_DIR}/test_helper/bats-file/load"
  load "${TEST_DIR}/test_helper/bats-support/load"
}

@test "Successfully completed script execution" {
  # nixos-fde-config is executed by the setup_suite function and all relevant
  # output is lost before this test can start. Executing
  # nixos-fde-config --resume will directly go to the end of the script and
  # display the completion message, if the previous execution went smoothly.
  run expect -c "
  spawn ${EXP_SSH} /root/nixos-fde-config --resume
  match_max 100000
  expect \"Would you like to continue? \[y/N] \"
  send -- \"y\n\"
  expect \"Hit q to exit.\"
  send -- \"q\"
  expect eof"

  assert_line --partial "Finished preparing installation"
  assert_success
}
