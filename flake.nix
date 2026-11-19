{
  description = "VotV for Linux through Wine";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    {
      self,
      nixpkgs,
      ...
    }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];

      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});
    in
    {
      packages = forAllSystems (
        pkgs:
        let
          votv = pkgs.callPackage ./package { };
        in
        {
          inherit votv;
          default = votv;
        }
      );

      homeModules = {
        votv = import ./module.nix { inherit self; };
      };
    };
}
