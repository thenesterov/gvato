{ pkgs, self, system }:

let
  imports = import ../imports.nix { inherit (pkgs) lib; };
in
  imports {
    path = ./.;
    args = { inherit pkgs self system; };
  }

