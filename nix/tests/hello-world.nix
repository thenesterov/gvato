{ pkgs, self, system }:

let
  version = import ../version.nix { inherit pkgs; };
in  
  pkgs.testers.nixosTest {
    name = "gvato-hello-world-test";
    nodes.machine = { ... }: {
      virtualisation.docker.enable = true;
    };

    testScript = ''
      machine.wait_for_unit("docker.service")
      machine.succeed("docker load < ${self.packages.${system}.image-amd64}")
      machine.succeed("docker run --rm ghcr.io/thenesterov/gvato:${version}-amd64")
    '';
  }

