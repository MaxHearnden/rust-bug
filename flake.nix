# This is a nix flake
# to build run nix build

{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = { nixpkgs, self }:
  let inherit (nixpkgs) legacyPackages lib;
  in {
    packages = lib.mapAttrs (system: pkgs:
      let
        hostPackages =
          if builtins.elem system lib.platforms.riscv then
            pkgs
          else
            pkgs.pkgsCross.riscv64;
      in {
        default = hostPackages.callPackage ./package.nix { };
        inherit hostPackages;
      }) legacyPackages;
  };
}
