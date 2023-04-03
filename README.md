# nixos-fde-config

> [!IMPORTANT]
> This project is still in active development. So, expect breaking changes without
> prior notice.
>
> Outside contributions might be included in future stable versions.

## Table of contents

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Description](#description)
- [Features](#features)
- [Minimum requirements](#minimum-requirements)
- [Installation](#installation)
- [Help page](#help-page)
- [Live demo](#live-demo)
  - [VM requirements](#vm-requirements)
  - [Instructions](#instructions)
- [Dependencies](#dependencies)
- [Attribution](#attribution)
- [License](#license)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Description

`nixos-fde-config` is a configuration script for creating a NixOS system with
full-disk encryption (FDE NixOS). Unlike other Linux installations, this script
stores the EFI System Partition (ESP) on a detachable medium instead of keeping
it at the head of the main disk.

The main disk is [LUKS][1] encrypted in its entirety, with a detached header stored
in a file. This way, the device contains no visible/detectable metadata.

The header file is in turn compressed, passphrase protected, then added to the
system's boot image.

![Screen capture of a running nixos-fde-config script](/assets/demo/install-demo.svg)

To start your NixOS system, plug the detachable medium into your computer,
power it, then provide your passphrase when prompted.

![Screen capture of a booting full-disk encrypted NixOS](/assets/demo/boot-demo.svg)

That's it, you have a two-factor protected, full-disk encrypted NixOS!

[↑ ToC](#table-of-contents)

## Features

- It is impossible to start your computer without the detachable medium
  configured at installation time (or a backup copy).

- It is impossible to start your computer without your passphrase.

- Your main disk is fully encrypted, with no visible metadata. A threat actor
  getting access to your hard drive at rest cannot know it is encrypted.

- The LUKS container on your main disk is protected by a randomly generated
  keyfile.

- Built as an LVM-on-LUKS partition, SWAP is automatically encrypted. No risk
  of leaking sensitive information when your system hibernates (i.e. saves data
  in RAM to disk before power off).

- System and home partitions are on ext4-formatted LVM volumes, resizeable
  while the system is still running.

- **Coming soon**: [`bootkey-utils`][2] a suite of command-line utilities to
  create, synchronize, and manage your bootkeys .

- **Work in progress**: UEFI secure boot support for a signed bootloader.
  For the moment, you cannot boot a NixOS system on a machine with UEFI Secure
  Boot enabled. This feature is awaiting a solution to this [open issue][3].

## Minimum requirements

- Hard drive: at least 16GiB.

- USB key: larger than 2GiB.

## Installation

From a terminal window in a booted [NixOS Minimal or Graphical ISO image][4]:

```console
# Log in as root.
sudo -i

# Add Nix Flakes support
echo "experimental-features = fetch-tree flakes nix-command" >> /root/nix.conf

# Set the location of the Nix user configuration files to load
export NIX_USER_CONF_FILES="/root/nix.conf:$NIX_USER_CONF_FILES"

# Install the latest version of `nixos-fde-config` in a temporary environment.
nix shell github:nickpiaddo/nixos-fde-config
```

To check that `nixos-fde-config` is setup correctly, run the command
`nixos-fde-config --help` which should output a help page like the one below.

Look at the `EXAMPLES` to learn how to use `nixos-fde-config`.

[↑ ToC](#table-of-contents)

## Help page

```text
   USAGE

       nixos-fde-config -m DEVPATH -b DEVPATH -R SIZE -S SIZE [-H SIZE]
                        [--skip-wipe-disks]

       nixos-fde-config --save-hash DEVPATH

       nixos-fde-config --help

       nixos-fde-config --help-rescue

       nixos-fde-config --reset

       nixos-fde-config --resume

       nixos-fde-config --version

   EXAMPLES

       Configure a system with a bootkey at /dev/sdb, a main disk at /dev/sda
       with a 16G root partition, 8G of swap, and a 64G /home partition.

           nixos-fde-config -b /dev/sdb -m /dev/sda -R 16G -S 8G -H 64G

       By default, not specifying the size of the home partition will allocate
       all remaining free space to it. In the example below, the home partition
       will have size home_size = disk_size - (root_size + swap_size).

           nixos-fde-config -b /dev/sdb -m /dev/sda -R 16G -S 8G

       If you do not want a dedicated partition for the /home directory, set
       its size to zero.

           nixos-fde-config -b /dev/sdb -m /dev/sda -R 16G -S 8G -H 0

      Equally, if you want a system without a swap partition set its value to
      zero.

           nixos-fde-config -b /dev/sdb -m /dev/sda -R 16G -S 0 -H 0

   DESCRIPTION

       nixos-fde-config is a setup script for configuring a NixOS system with
       full disk encryption.

       It creates a LUKS2 encrypted container on the given main disk, then adds
       up to three ext4-formatted LVM volumes (root, swap, home).

       The LUKS2 container's header-file, along with a decryption key-file are
       added as a compressed, passphrase-protected archive to a UEFI boot
       partition on the USB bootkey.

       After a successful setup, the bootkey is required to boot the system.
       You will also need to provide your passphrase to mount the filesystem.

       Note: When sizing your partitions, take into account that 16MiB
             are reserved on the main disk for GPT and LVM metadata.

   OPTIONS

       -h, --help               Display this help and exit.
       --help-rescue            Display instructions for rescuing a failed
                                NixOS install.
       -z, --resume             Resume execution from the last successful step
                                before interruption.
       --reset                  Revert main disk to a safe state before script
                                re-execution.
       --version                Print script version string.

       -m, --main-disk DEVPATH  Specify where to install NixOS.
       -b, --boot-key  DEVPATH  Specify where to put the boot partition.
       -R, --root-size SIZE     Specify the root partition size.
       -S, --swap-size SIZE     Specify the swap partition size.
       -H, --home-size SIZE     Specify the home partition size. (Optional)
                                (default: remaining free space after root
                                 and swap partitions)

       --save-hash DEVPATH      Compute and save a checksum of the bootkey in
                                fde-configuration.nix

       --skip-wipe-disks        Skip wiping disks with random data before
                                formatting.

                                Wiping a disk with random data, before creating
                                the LUKS container, helps hide the size of the
                                encrypted content and gives you plausible
                                deniability about its very existence.
                                Use this option at your own risk!

       Command parameters:

       DEVPATH the absolute path to a disk (e.g. /dev/sda).

       SIZE the integer partition size in bytes. Must be at least 8GiB for the
       root partition. Otherwise, either 0 or at least 4MiB.

       Optional suffixes k or K (kibibyte, 1024 bytes), M (mebibyte, 1024k),
       G (gibibyte, 1024M), and T (tebibyte, 1024G) are supported.
```

[↑ ToC](#table-of-contents)

## Live demo

### VM requirements

- Disk space: 36GiB
- RAM: 4GiB

### Instructions

> [!WARNING]
> When first executed, the `start-demo-vm` script will need tens of minutes
> to download all necessary packages, build, install, and boot a virtual
> machine with FDE NixOS.
>
> If you did not delete the files produced by the setup process, subsequent
> boots will be near instantaneous.

If you are already running a NixOS system and would like a taste of FDE NixOS,
follow the instructions below.

In a dedicated terminal window:

```console
# Clone this repository
git clone https://github.com/nickpiaddo/nixos-fde-config

# Step into the cloned directory
cd nixos-fde-config

# Start a development shell
nix-shell

# Create and start a demo virtual machine
./utils/start-demo-vm
```

When prompted for a passphrase, during the boot sequence, input `nixos` then
hit `Enter`.

Once you have reached a login prompt, use the credentials below:

- login: `root`
- password: `nixos`

You can now explore the system at leisure.

To exit the VM, either hit `Ctrl+C` or execute the script `utils/stop-demo-vm`
in another terminal.

[↑ ToC](#table-of-contents)

## Dependencies

- [Age](https://age-encryption.org/)
- [b3sum](https://github.com/BLAKE3-team/BLAKE3/)
- [Pipe Viewer](https://www.ivarch.com/programs/pv)

## Attribution

The how-to guides below were a great source of inspiration for the project.

[User:Sakaki/Sakaki's EFI Install Guide][5]

[How to Install NixOS With Full Disk Encryption (FDE) using LUKS2,...][6]

## License

This project is licensed under either of the following (at your discretion):

- [Apache License, Version 2.0][7]
- [MIT License][8]

Files in the [third-party/][9] and [web-snapshots/][10] directories are subject
to their own licenses and/or copyrights.

SPDX-License-Identifier: Apache-2.0 OR MIT

Copyright (c) 2023 Nick Piaddo

[1]: https://en.wikipedia.org/wiki/Linux_Unified_Key_Setup
[2]: https://github.com/nickpiaddo/bootkey-utils
[3]: https://github.com/NixOS/nixpkgs/issues/42127
[4]: https://nixos.org/download/
[5]: https://wiki.gentoo.org/wiki/User:Sakaki/Sakaki%27s_EFI_Install_Guide
[6]: https://shen.hong.io/installing-nixos-with-encrypted-root-partition-and-seperate-boot-partition/
[7]: https://www.apache.org/licenses/LICENSE-2.0
[8]: https://opensource.org/licenses/MIT
[9]: /third-party/
[10]: /web-snapshots/
