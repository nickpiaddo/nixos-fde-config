# Copyright (c) 2023 Nick Piaddo
# SPDX-License-Identifier: Apache-2.0 OR MIT

{ pkgs, modulesPath, lib, config, ... }: {
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
  ];

  # Send console output to first UART serial port ttyS0
  # inspired by:
  # https://fadeevab.com/how-to-setup-qemu-output-to-console-and-automate-using-shell-script/
  config.boot.kernelParams = [ "console=ttyS0" ];

  # Reduce default timeout from 10 to 0 second
  config.boot.loader.timeout = lib.mkForce 0;

  # Enable Flakes support
  config.nix.settings.experimental-features = [ "flakes" "nix-command" ];

  # Authorize password-less SSH connection by root user
  # https://github.com/NixOS/nixpkgs/issues/119710#issuecomment-1899293945
  config.services.openssh.enable = true;
  config.services.openssh.passwordAuthentication = true;
  config.services.openssh.settings.PermitRootLogin = "yes";
  config.services.openssh.settings.PermitEmptyPasswords = "yes";
  config.security.pam.services.sshd.allowNullPassword = true;
  config.users.users.root.hashedPassword = "";
}
