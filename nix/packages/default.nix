{ pkgs, pkgsUnstable }:

let
  mkGvato = import ./gvato.nix { inherit pkgs pkgsUnstable; };
  mkImage = import ./docker.nix { inherit pkgs pkgsUnstable; };
  
  gvato-amd64 = mkGvato "x86_64";
  gvato-arm64 = mkGvato "aarch64";
in {
  default = mkGvato "native";
  inherit gvato-amd64 gvato-arm64;
  
  image-amd64 = mkImage gvato-amd64 "x86_64";
  image-arm64 = mkImage gvato-arm64 "aarch64";
}

