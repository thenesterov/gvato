{ pkgs }:

pkgs.lib.trim (builtins.readFile ../.version)

