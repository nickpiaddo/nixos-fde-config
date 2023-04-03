<!-- DOCTOC SKIP -->
# How to create `install-demo.svg`

1. In a dedicated terminal, start the test VM with `just sv` (or `just
   start-test-vm`).

2. Copy `nixos-fde-config` from the host to the VM:
   `./utils/scp-test-vm nixos-fde-config root@localhost:/root`

3. In the VM window:
   1. login as root `sudo -i`
   2. install `termtosvg` with the command `nix-env -iA nixos.termtosvg`
   3. run

      ```shell
      termtosvg install-demo.svg -g 80x30 -c "./nixos-fde-config -m /dev/sda -b
      /dev/sdb -R 10G -S 4G -H 12G --skip-wipe-disks"
      ```

4. Copy `install-demo.svg` from the VM to the host

   ```shell
   ./utils/scp-test-vm root@localhost:/root/install-demo.svg
   assets/demo/install-demo.svg
   ```

5. Stop the VM with `just xv` (or `just stop-test-vm`)
