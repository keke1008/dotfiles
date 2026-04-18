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

    systemd.user.services.kanata = {
      Unit = {
        Description = "kanata";
        After = "graphical-session.target";
        PartOf = "graphical-session.target";
      };

      Service = {
        ExecStart = "${lib.getExe pkgs.kanata} --no-wait";
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
