{
  config,
  lib,
  ...
}:
{
  options.keke.nix = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable custom nix configuration";
    };
  };

  config = lib.mkIf config.keke.nix.enable {
    nix.settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [
        "root"
        "@wheel"
      ];
    };
    nixpkgs.config.allowUnfree = true;
  };
}
