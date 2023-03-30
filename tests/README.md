# Unit Tests

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Directory structure](#directory-structure)
- [Running unit tests](#running-unit-tests)
- [Running integration tests](#running-integration-tests)
- [Troubleshooting](#troubleshooting)
  - [Submodules not initialized](#submodules-not-initialized)
  - [Test VM not started](#test-vm-not-started)
  - [Started running tests before the test VM has finished booting](#started-running-tests-before-the-test-vm-has-finished-booting)
  - [Trying to start two test VMs](#trying-to-start-two-test-vms)
  - [Trying to stop a non-running test VM](#trying-to-stop-a-non-running-test-vm)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Directory structure

```text
tests
├── on-demo-vm  # Integration test suite
│   ├── 01-integration-tests.bats
│   └── setup_suite.bash
│
├── on-install-iso
│   │
│   ├── option-parsing  # Command options parsing test suite
│   │   ├── 00-no-parameters.bats
│   │   ├── 01-help-option.bats
│   │   ├── ...
│   │   └── setup_suite.bash
│   │
│   └── system-configuration  # Installation steps test suite
│       ├── 01-setup-installation-tools.bats
│       ├── 02-prepare-boot-key.bats
│       ├── ...
│       └── setup_suite.bash
│
├── README.md
│
└── test_helper  # BATS libraries
    ├── bats-assert
    ├── bats-file
    └── bats-support
```

## Running unit tests

To ensure you will get a smooth development process, there are unit tests
for checking command-line option parsing, and system configuration in two test
suites.

We use the [`just`](https://just.systems/man/en/) command runner to run
project-specific commands. Invoke `just --list` to see a list of all available
recipes.

> [!IMPORTANT]
> You must execute `just start-test-vm` in a dedicated terminal window
> **before** calling `just test` for the first time.

Calling `just test` from the root directory will execute both test suites. You
can run each test suite separately:

- `just test-options`: to check command-line option parsing
- `just test-config`: to check that `nixos-fde-config` operates as expected

Unit tests are run through a test virtual machine (VM).

To create a test VM, use the command `just start-test-vm` (or `just sv`) in a
dedicated terminal window. It will provision, then start a local virtual
machine.

On its first run, `just start-test-vm` will create VM disk files, and a custom
installation ISO.

Be aware that building the ISO can be time consuming. Thankfully, subsequent
invocations will go faster since the ISO image is saved in the nix store.

As long as the test VM is running, you can edit and test your
`nixos-fde-config` by executing `just test` in a terminal.

Once your coding session is over, stop the test VM by closing its window, or by
running the command `just stop-test-vm`.

To ease interactions with the test VM, we provide several helper scripts in the
[`utils`](/utils) folder. Among them, scripts for copying files from/to the VM,
or connecting to it via SSH.

## Running integration tests

Contrary to `just test`, which requires you to manually create a test VM, the
`just test-integration` command is fully automated.

To mimic an end-user executing  `nixos-fde-config`, the command will
first provision a session VM, then simulate the whole installation process of
an FDE NixOS.

The `just test-integration` command takes several minutes to run, and will seem
unresponsive (since the test framework captures all outputs). So **give it
time!**

You can follow the program's progress, by executing the command `tail -f
/tmp/bats-run-**/suite.out`in a second terminal window (use Ctrl-C to exit).

Since integration test VMs are ephemeral, we provide a manual version (demo VM)
that you can start with `utils/start-demo-vm`.

On first run, it will automatically execute the full installation process, then
boot the system; subsequent runs will reuse the generated files if present.

Provide the passphrase `nixos` at the `Enter passphrase:` prompt.

The demo machine is configured to have one user, `root` with password `nixos`.

If needs be, there are scripts in the [`utils`](/utils) folder for connecting
to the demo VM via SSH, or copy files from/to it.

## Troubleshooting

As always, deleting the VM files to start fresh can solve many problems.
However, the solutions below might save you some time and effort.

### Submodules not initialized

If you see the error message below while using `just test`, chances are you
just cloned the repository and didn't initialize the git submodules.

```console
nick | ➜  just test
   ⇥ Copying nixos-fde-config to test VM...
00-no-parameters.bats
 ✗ Running nixos-fde-config without parameters prints usage
   (from function `setup' in test file test/on-install-iso/option-parsing/
   00-no-parameters.bats, line 1)
     `setup() {' failed
   bats_load_safe: Could not find '/home/nick/nixos-fde-config/test/test_helper/
   bats-assert/load'[.bash]
```

Solution:

```console
# Initialize BATS libraries
git submodule update --init --recursive
```

### Test VM not started

If you see the error message below while using `run-unit-tests`, it is most
likely because you forgot to start a test virtual machine before running the
unit tests.

```console
nick | ➜  just test
Unit Test CLI Option Parsing:
 ✗ setup_suite []
   (from function `setup_suite' in test file
   tests/on-install-iso/option-parsing/setup_suite.bash, line 60)
     `bash -c "${SCP} \' failed with status 255
   ssh: connect to host localhost port 2222: Connection refused
   scp: Connection closed
   bats warning: Executed 1 instead of expected 80 tests

80 tests, 1 failure, 79 not run in 2 seconds

error: Recipe `test-options` failed on line 37 with exit code 1
```

Solution:

```console
# Run the command below in a dedicated terminal window first, then start your
# test suite.
just start-test-vm
```

### Started running tests before the test VM has finished booting

Sometimes, if you run unit tests just a few seconds after booting the test VM,
you might see it print the error message below.

```console
nick | ➜  just test
Unit Test CLI Option Parsing:
 ✗ setup_suite
   (from function `setup_suite' in test file test/on-install-iso/option-parsing/
   setup_suite.bash, line 58)
     `bash -c "${SCP} \' failed with status 255
   kex_exchange_identification: read: Connection reset by peer
   Connection reset by 127.0.0.1 port 2222
   scp: Connection closed
   bats warning: Executed 1 instead of expected 60 tests

60 tests, 1 failure, 59 not run
```

Solution:

Wait a few seconds, or see if the test VM's output looks like the one below,
and try again.

```console
<<< Welcome to NixOS 22.11.2630.e6d5772f351 (x86_64) - ttyS0 >>>
The "nixos" and "root" accounts have empty passwords.

An ssh daemon is running. You then must set a password
for either "root" or "nixos" with `passwd` or add an ssh key
to /home/nixos/.ssh/authorized_keys be able to login.

If you need a wireless connection, type
`sudo systemctl start wpa_supplicant` and configure a
network using `wpa_cli`. See the NixOS manual for details.


Run 'nixos-help' for the NixOS manual.

nixos login: nixos (automatic login)


[nixos@nixos:~]$
```

### Trying to start two test VMs

If you see the error message below, then a test VM is already running.

```console
nick | ➜  just start-test-vm
./utils/start-test-vm
Starting virtual machine at: /home/nick/Lab/nixos/nixos-fde-config/area51/test-vm
> QEMU monitor listening on port: 45454
> SSH server listening on port: 2222
qemu-system-x86_64: -monitor telnet::45454,server,nowait: Failed to find an
available port: Address already in use

```

Solution:

```console
# Either do nothing, or run the command below in another terminal first, then
# restart your test VM.
just stop-test-vm
```

### Trying to stop a non-running test VM

If you see the error message below, you tried to stop a virtual machine that
was already stopped.

```console
nick | ➜  just stop-test-vm
./utils/stop-test-vm
Stopping virtual machine...
> Connecting to QEMU monitor on port: 45454
Error: Found no running virtual machine.
```

Solution:

```console
# Nothing to do, your test VM is already offline.
```
