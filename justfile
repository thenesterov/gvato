set positional-arguments

container-manager := "podman"  # or docker
default-architecture := "amd64"  # or arm64
default-binary-architecture := "x86_64"  # or aarch64
version := `cat .version`

[private]
default:
    @just --list

[doc("Clean all temporary files")]
clean installation-prefix="zig-out/":
    @rm -rf result \
        image-amd64 image-arm64 \
        .zig-cache/ {{ installation-prefix }}

[doc("Bump version")]
bump version:
    echo {{ version }} > .version
    git add .version
    git commit -m "bump(.version): {{ version }}"
    git tag -a {{ version }}

[group("zig")]
[doc("Alias for zig build")]
zig-build *args="":
    zig build -Dversion={{ version }} {{ args }}

[group("zig")]
[doc("Run the binary")]
zig-run-binary *args="":
    ./zig-out/bin/gvato {{ args }}

[group("zig")]
[doc("Alias for zig build tests")]
zig-run-tests:
    zig build test

[group("nix")]
[doc("Alias for nix build")]
nix-build:
    nix build .#gvato-{{ default-architecture }}

[group("nix")]
[doc("Run the binary with nix")]
nix-run-binary:
    ./result/bin/gvato

[group("nix")]
[doc("Build image and load it")]
nix-build-image:
    nix build .#image-{{ default-architecture }} --out-link image-{{ default-architecture }}
    {{ container-manager }} load < image-{{ default-architecture }}

[group("nix")]
[doc("Run container")]
nix-run-container *args="":
    {{ container-manager }} run ghcr.io/thenesterov/gvato:{{ version }}-{{ default-architecture }} {{ args }}

[group("nix")]
[doc("Alias for nix flake check")]
nix-run-tests:
    nix flake check

[group("nix")]
[doc("Run specific nix test")]
nix-run-test name *args="":
    nix build .#checks.{{ default-binary-architecture }}-linux.{{ name }} {{ args }}

