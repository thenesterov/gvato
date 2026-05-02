{
  description = "Gvato Development Environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        pkgsUnstable = import nixpkgs-unstable { inherit system; };
      in {
        packages = import ./nix/packages { inherit pkgs pkgsUnstable; };
        checks = import ./nix/tests { inherit pkgs self system; };
        devShells.default = import ./nix/shell.nix { inherit pkgs pkgsUnstable; };
      }
    );
}

