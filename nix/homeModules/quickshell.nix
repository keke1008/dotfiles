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

    systemd.user.services.quickshell =
      let
        targets = [
          "wayland-session@sway.desktop.target" # Managed by UWSM
        ];
      in
      {
        Unit = {
          Description = "Quickshell";
          After = targets;
          PartOf = targets;
        };

        Service = {
          ExecStart = lib.getExe pkgs.quickshell;
        };

        Install = {
          WantedBy = targets;
        };
      };
  };
}
