{ lib, config, ... }:
{
  options.keke.nix = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable custom nix configuration";
    };
  };

  config = lib.mkIf config.keke.nix.enable {
    nixpkgs = {
      config.allowUnfree = true;
    };
  };
}
