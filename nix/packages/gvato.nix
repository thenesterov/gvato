{ pkgs, pkgsUnstable }:

let
  version = import ../version.nix { inherit pkgs; };
in
  target: pkgs.stdenv.mkDerivation {
    pname = "gvato-${target}";
    version = version;
    src = pkgs.lib.cleanSource ../..;
    dontRewriteSymlinks = true;
    noAuditTmpdir = true;
    nativeBuildInputs = [ pkgsUnstable.zig.hook ];
    zigBuildFlags = [ "-Doptimize=ReleaseSafe" "-Dtarget=${target}-linux-musl" "-Dversion=${version}" ];
    postInstall = ''
      ${pkgs.removeReferencesTo}/bin/remove-references-to -t ${pkgsUnstable.zig} $out/bin/gvato
    '';
  }

