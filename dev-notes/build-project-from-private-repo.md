<!-- DOCTOC SKIP -->
# Build the project from a private repository

In a test Virtual Machine:

1. Create a fine-grained access token ([Github docs][1]) with permission `Read
   access to code and metadata`.

2. Save the token to a file (e.g. named `access-token`).

3. Create a script named `build-script` containing the following code

   ```bash
   #!/usr/bin/env bash

   # Script template inspired by
   # https://sharats.me/posts/shell-script-best-practices/
   set -o errexit
   set -o nounset
   set -o pipefail
   shopt -s globstar
   shopt -s nullglob

   # Run script `TRACE=1 ./script [options]' to enable tracing
   if [[ "${TRACE-0}" == "1" ]]; then
     set -o xtrace
   fi

   if [[ ! -d /root/.config/nix ]]; then
     mkdir -p /root/.config/nix
     echo "experimental-features = fetch-tree flakes nix-command" >> /root/.config/nix/nix.conf
   fi

   export NIX_USER_CONF_FILES="/root/.config/nix/nix.conf"

   if [[ ! -f /root/access-token ]]; then
     echo "Missing file '/root/access-token'"
     exit 1
   else
     ACCESS_TOKEN="$(tr -d '[:blank:]' < /root/access-token)"
   fi

   nix build "git+https://nickpiaddo:${ACCESS_TOKEN}@github.com/nickpiaddo/nixos-fde-config.git"
   ```

4. Make `build-script` executable `chmod +x build-script`

5. Copy both files to the test VM.

6. From the VM, run the script.

[1]: https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens#creating-a-fine-grained-personal-access-token
