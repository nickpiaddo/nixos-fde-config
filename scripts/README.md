<!-- DOCTOC SKIP -->
# Scripts

Every script in this directory can print a help page explaining what it does.
Use `./<script_name> --help` to get more information.

- `build-demo-vm`: Build the components of a demo virtual machine to simulate a
  full-disk encrypted NixOS system.

- `build-test-harness`: Install Bash Automated Testing System (BATS) libraries
  bats-assert, bats-file, and bats-support in the output directory.

- `build-test-vm`: Build the components of a development virtual machine for
  setting up and testing a full-disk encrypted NixOS system.

- `build-vm`: Build the components of a development virtual machine for a
  full-disk encrypted NixOS system.

- `start-vm`: Start a virtual machine produced by `build-vm`.

- `stop-vm`: Stop a virtual machime started by `start-vm`.

- `load-vm`: Load a virtual machime snapshot.
