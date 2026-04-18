{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.keke.eww = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Eww";
    };
  };

  config = lib.mkIf config.keke.eww.enable {
    home.packages = with pkgs; [
      bluez # bluetoothctl
      eww
      jq
      playerctl
      pulseaudio # pactl
      util-linux # rfkill
      wireplumber # wpctl
    ];

    systemd.user.services.eww = {
      Unit = {
        Description = "Eww";
        After = "graphical-session.target";
        PartOf = "graphical-session.target";
      };

      Service = {
        ExecStart = "${lib.getExe pkgs.eww} daemon --no-daemonize";
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
