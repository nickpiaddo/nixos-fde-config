# Copyright (c) 2023 Nick Piaddo
# SPDX-License-Identifier: Apache-2.0 OR MIT

setup_suite() {
  DIR="$(cd "$(dirname "$BATS_TEST_FILENAME")" >/dev/null 2>&1 && pwd)"
  BASE_DIR="$(realpath "${DIR}/../..")"
  CONF_DIR="${BASE_DIR}/config"
  TEST_DIR="${BASE_DIR}/tests"
  SCRIPTS_DIR="${BASE_DIR}/scripts"

  # make executables visible to PATH
  PATH="${SCRIPTS_DIR}:$PATH"

  ROOT_PASSWD="nixos"
  PASSPHRASE="${ROOT_PASSWD}"

  PORT_OFFSET=3
  DEFAULT_SSH_PORT=2222
  DEFAULT_VM_MON_PORT=45454

  SSH_OPTIONS="\
    -oUserKnownHostsFile=/dev/null \
    -oStrictHostKeyChecking=no \
    -oPasswordAuthentication=yes"

  # VM SSH port redirection
  SSH_PORT=$((DEFAULT_SSH_PORT + PORT_OFFSET))

  # For running command on the VM
  SSH="passh -p ${ROOT_PASSWD} ssh root@localhost -p ${SSH_PORT} -t ${SSH_OPTIONS}"

  # VM monitor listening port
  VM_MON_PORT=$((DEFAULT_VM_MON_PORT + PORT_OFFSET))

  # Location of temporary VM files
  VM_DIR="$(mktemp --tmpdir=/tmp --directory nixos-fde-dummy.XXXXXXXXXX)"

  export BASE_DIR
  export SCRIPTS_DIR
  export TEST_DIR
  export SSH
  export SSH_PORT
  export VM_DIR
  export VM_MON_PORT

  echo "# 🛠 Building integration test VM..." >&3
  build-demo-vm -c "${CONF_DIR}/no-root-password-install-iso.nix" \
    -d "${CONF_DIR}/demo-vm-configuration.nix" \
    -m "${VM_MON_PORT}" -p "${SSH_PORT}" -o "${VM_DIR}" 3>&-

  echo "# ⏵ Starting integration test VM..." >&3
  expect -c "
  set timeout -1
  spawn ${SCRIPTS_DIR}/start-vm ${VM_DIR} ${VM_MON_PORT} ${SSH_PORT} --no-graphic
  # Unlock LUKS container
  expect \"Enter passphrase: \"
  send -- \"${PASSPHRASE}\n\"
  expect eof" 3>&- &
}

teardown_suite() {
  echo "# ⏹ Stopping integration test VM..." >&3
  stop-vm "${VM_MON_PORT}" 3>&-
  echo "# 🗙 Deleting temporary files..." >&3
  rm -rf "${VM_DIR}"
}
