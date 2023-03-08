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
        revision = self.shortRev or "dirty";
        version = "${semver}-${date}.${revision}";

        # Nixpkgs instantiated for supported system types.
        pkgs = import nixpkgs { inherit system; };

      in
      {
        # Development environment
        devShell = pkgs.mkShell {
          # Packages necessary for script development.
          packages = with pkgs; [
            # Command runner
            just

            # For unit and integration testing
            nixos-generators

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
        };
      });
}
