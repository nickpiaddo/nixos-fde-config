# Copyright (c) 2023 Nick Piaddo
# SPDX-License-Identifier: Apache-2.0 OR MIT

setup_suite() {
  DIR="$(cd "$(dirname "$BATS_TEST_FILENAME")" >/dev/null 2>&1 && pwd)"
  BASE_DIR="$(realpath "${DIR}/../../..")"
  TEST_DIR="${BASE_DIR}/tests"

  DEFAULT_SSH_PORT=2222

  SSH_OPTIONS="\
    -oUserKnownHostsFile=/dev/null \
    -oStrictHostKeyChecking=no \
    -oPasswordAuthentication=yes"

  SSH_PORT=${DEFAULT_SSH_PORT}

  ### ======= Uncomment section for full-automatic testing
  #CONF_DIR="${BASE_DIR}/config"
  #SCRIPTS_DIR="${BASE_DIR}/scripts"

  ## make executables visible to PATH
  #PATH="${SCRIPTS_DIR}:$PATH"
  ## VM files location
  #VM_DIR="$(mktemp --tmpdir=/tmp --directory nixos-fde.XXXXXXXXXX)"

  ## VM SSH port redirection
  #PORT_OFFSET=2
  #SSH_PORT=$((DEFAULT_SSH_PORT + PORT_OFFSET))

  ## VM monitor listening port
  #DEFAULT_VM_MON_PORT=45454
  #VM_MON_PORT=$((DEFAULT_VM_MON_PORT + PORT_OFFSET))

  #echo "# 🛠 Bootstrapping test VM..." >&3
  #build-vm -c "${CONF_DIR}/no-root-password-install-iso.nix" \
  #  -o "${VM_DIR}" 3>&-
  #echo "# ⏵ Starting test VM..." >&3
  #start-vm -d "${VM_DIR}" -m "${VM_MON_PORT}" -p "${SSH_PORT}" 3>&- &
  ## Wait a few seconds for the VM to start an SSH server
  #sleep 10

  #export VM_DIR
  #export VM_MON_PORT
  ## =======

  # For running command on the VM
  export SSH="passh -p '' ssh root@localhost -p ${SSH_PORT} -t ${SSH_OPTIONS}"

  # For running command on the VM through expect
  EXP_SSH="passh -p {} ssh root@localhost -p ${SSH_PORT} -t ${SSH_OPTIONS}"

  # For copying files to the VM
  SCP="passh -p '' scp -P ${SSH_PORT} ${SSH_OPTIONS}"

  export BASE_DIR
  export TEST_DIR

  echo "# ⇥ Copying nixos-fde-config to test VM..." >&3
  bash -c "${SCP} \
    ${BASE_DIR}/nixos-fde-config \
    root@localhost:~/" 3>&-

  echo "# ⚙ Running nixos-fde-config..." >&3
  expect -c "
  match_max 100000
  spawn ${EXP_SSH} /root/nixos-fde-config --reset
  expect eof
  spawn ${EXP_SSH} /root/nixos-fde-config -x -m /dev/sda -b /dev/sdb -R 16G -S 4G -H 10G
  while {true} {
    expect {
      \"Would you like to continue\" { send -- \"y\n\"; }
      eof { exit; }
    }
  } " 3>&-
}

## ======= Uncomment section for full-automatic testing
#teardown_suite() {
#  echo "# ⏹ Stopping test VM..." >&3
#  stop-vm -p ${VM_MON_PORT} 3>&-
#  echo "# 🗙  Deleting temporary files..." >&3
#  rm -rf "${VM_DIR}"
#}
## =======
