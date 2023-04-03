<!-- DOCTOC SKIP -->
# How to create `boot-demo.svg`

1. > [!WARNING]
   > This step requires a robust internet connection, and some patience...

   From the base directory, create the demo VM with the command
   `./scripts/build-demo-vm -c config/no-root-password-install-iso.nix -d
   config/demo-vm-configuration.nix -m 45400 -p 2200 -o area51/demo-vm`

2. In a dedicated terminal, execute `termtosvg assets/demo/boot-demo.svg -g
   80X30 -c "./scripts/start-vm area51/demo-vm 45400 2200 --no-graphic"`

3. At the prompt `Enter passphrase:`, type `nixos` then hit `Enter`.

4. Hit `Ctrl-C` to stop recording.
