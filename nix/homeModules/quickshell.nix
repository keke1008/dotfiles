{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.keke.quickshell = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable quickshell";
    };
  };

  config = lib.mkIf config.keke.quickshell.enable {
    home.packages = with pkgs; [
      quickshell
      kdePackages.qtdeclarative
      material-symbols
    ];

    qt = {
      enable = true;
      platformTheme.name = "gtk3";
    };
  };
}
