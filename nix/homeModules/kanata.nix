{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.keke.kanata = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable kanata configuration";
    };
  };

  config = lib.mkIf config.keke.kanata.enable {
    home.packages = with pkgs; [
      kanata
    ];
  };
}
