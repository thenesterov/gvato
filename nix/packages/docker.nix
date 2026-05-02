{ pkgs, pkgsUnstable }:

let
  version = import ../version.nix { inherit pkgs; };
  getDockerArch = target: { "x86_64" = "amd64"; "aarch64" = "arm64"; }.${target};
in
  gvatoPkg: target: pkgs.dockerTools.buildLayeredImage {
    name = "ghcr.io/thenesterov/gvato";
    tag = "${version}-${getDockerArch target}";
    architecture = getDockerArch target;
    contents = [ gvatoPkg pkgs.cacert ];
    config = {
      Cmd = [ "/bin/gvato" ];
      Env = [ "SSL_CERT_FILE=/etc/ssl/certs/ca-bundle.crt" ];
    };
  }

