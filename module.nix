{ self }:
{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.programs.votv;

  votv = pkgs.callPackage ./package { extraVariables = cfg.extraVariables; };
in
{
  options.programs.votv = {
    enable = lib.mkEnableOption "Voices of the Void enable";

    extraVariables = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = [ ];
      description = "Additional environment variables";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      votv
    ];
  };
}
