# Copyright (c) 2023 Nick Piaddo
# SPDX-License-Identifier: Apache-2.0 OR MIT

setup() {
  load "${TEST_DIR}/test_helper/bats-assert/load"
  load "${TEST_DIR}/test_helper/bats-file/load"
  load "${TEST_DIR}/test_helper/bats-support/load"
}

@test "LUKS2 container unlocked" {
  sleep 30 # To give SSHd time to start
  run bash -c "${SSH} hostname"

  assert_success
  assert_line --partial "demo-vm"
}

@test "Main disk is encrypted" {
  run bash -c "${SSH} dmsetup table lukscontainer --showkeys"

  assert_success
  assert_line --partial "crypt aes-xts-plain64 :64:logon:cryptsetup"
}

@test "LUKS2 header and key present" {
  run bash -c "${SSH} head -n 2 /etc/nixos/initrd/secrets/secboot"

  assert_success
  assert_line --partial "age-encryption.org/v1"
  assert_line --partial "-> scrypt"
}

@test "Identical encrypted archive on system and boot-key" {
  run bash -c "${SSH} mount --target /boot"

  assert_success

  run bash -c "${SSH} cmp /etc/nixos/initrd/secrets/secboot /boot/EFI/extended/secboot"

  assert_success
}

@test "FDE configuration file present" {
  run bash -c "${SSH} head -n 25 /etc/nixos/fde-configuration.nix"

  # Saved primary bootkey
  REGEX_BOOTKEY_ID="(([a-z]{2,3})-([a-zA-Z0-9_-]+)(-[0-9]:[0-9])?(-part[0-9]+)?)"
  assert_regex "${REGEX_BOOTKEY_ID}"
  assert_line --partial "label = \"primary\";"
  # Saved hash of primary bootkey
  assert_line --regexp 'hash = "[a-fA-F0-9]{64}";'
  # FIXME command `nixos-fde-config --save-hash` does not seem to work when
  # automated
  # refute_line --regexp  'hash = "0{64}";'
  assert_success
}

##====== MUST ALWAYS RUN LAST
# This test has to restart the demo-vm VM before proceeding. Thus cutting off
# access to the initial VM created by `setup_suite`; initial VM needed by the
# test cases above to run correctly.
#
@test "Exceeding maximum allowed LUKS2 container unlock attempts triggers a panic" {
  run expect -c "
  set timeout -1
  spawn ${SCRIPTS_DIR}/stop-vm -p ${VM_MON_PORT}
  expect eof
  spawn ${SCRIPTS_DIR}/start-vm -d ${VM_DIR} -m ${VM_MON_PORT} -p ${SSH_PORT}
  # Exceed maximum number of attempts
  expect \"Enter passphrase: \"
  send -- \"passphrase\r\"
  expect \"Enter passphrase: \"
  send -- \"12345\r\"
  expect \"Enter passphrase: \"
  send -- \"password?\r\"
  # Panic message printed
  expect \"An error occurred in stage 1 of the boot process.\"
  # Reboot immediately
  send -- \"r\"
  exit" 3>&-

  assert_success
}
##======
