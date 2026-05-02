{ lib }:

{ path, args, exclude ? [ "default.nix" ] }:
  let
    files = builtins.readDir path;
    
    nixFiles = lib.filterAttrs (name: type:
      type == "regular" && 
      lib.hasSuffix ".nix" name && 
      !(builtins.elem name exclude)
    ) files;
  in
    lib.mapAttrs' (name: _: 
      let
        key = lib.removeSuffix ".nix" name;
      in
        lib.nameValuePair key (import (path + "/${name}") args)
    ) nixFiles

