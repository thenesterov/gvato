{ pkgs, pkgsUnstable }:

pkgs.mkShell {
  nativeBuildInputs = [
    pkgsUnstable.zig
    pkgs.just
  ];
}

