{
  description = "Script for building a full-disk encrypted NixOS machine.";

  # Nixpkgs / NixOS version to use.
  inputs.nixpkgs.url = "nixpkgs/nixos-25.05";

  # Set of functions to make flake nix packages simpler to set up without
  # external dependencies.
  inputs.flake-utils.url = "github:numtide/flake-utils";

  # Backward compatibility for people without flakes enabled.
  # https://github.com/edolstra/flake-compat
  inputs.flake-compat = {
    url = "github:edolstra/flake-compat";
    flake = false;
  };

  outputs = { self, nixpkgs, flake-compat, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let

        # to work with older version of flakes
        lastModifiedDate = self.lastModifiedDate or self.lastModified or "19700101";

        # Generate a user-friendly version number.
        semver = "0.1.0";
        date = builtins.substring 0 8 lastModifiedDate;
        revision = self.shortRev or "none";

        # Nixpkgs instantiated for supported system types.
        pkgs = import nixpkgs { inherit system; };

      in rec
      {
        # Development environment
        devShell = pkgs.mkShell {
          # Packages necessary for script development.
          packages = with pkgs; [
            # Command runner
            just

             # Markdown
            glow
            pandoc
            lynx
            w3m

            # For unit and integration testing
            bats
            expect
            inetutils
            ncurses
            nixos-generators
            OVMF
            openssh
            parallel
            passh
            python313
            python313Packages.uv
            python313Packages.pytest
            qemu
            tcl
            tcllib

            # For code linting and formatting
            doctoc
            nodejs_20
            marksman
            mdl
            pre-commit
            proselint
            ruby
            ruff
            shellcheck
            shfmt
            typos
          ];

          # Initialize submodules if necessary.
          shellHook = ''
              ./scripts/init-repo-submodules
            '';
        };

        # 'nix build' binary output
        packages = rec {
          default = nixos-fde-config;
          nixos-fde-config = pkgs.stdenv.mkDerivation rec {
            pname = "nixos-fde-config";
            version = "${semver}";
            src = ./.;

            nativeBuildInputs = [ pkgs.installShellFiles ];

            dontUnpack = true;
            dontPatch = true;
            dontConfigure = true;
            dontBuild = true;

            installPhase =
              ''
                # Install script
                mkdir -p $out/bin
                cp $src/nixos-fde-config $out/bin/
                chmod +x $out/bin/nixos-fde-config

                # Set version string
                sed -i s/##version##/v${version}/ $out/bin/nixos-fde-config
                sed -i s/##revision##/rev#${revision}/ $out/bin/nixos-fde-config

                runHook postInstall
              '';

            postInstall = ''
                # Install bash completion file
                installShellCompletion --bash --name nixos-fde-config.bash $src/nixos-fde-config-completion.bash
              '';
          };
        };

        # Make it runnable with 'nix run'
        apps = let
          nixos-fde-config = {
            type = "app";
            program = "${self.packages."${system}".nixos-fde-config}/bin/nixos-fde-config";
          };
        in {
          inherit nixos-fde-config;
          default = nixos-fde-config;
        };
      });
}
