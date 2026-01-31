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
      description = "Enable eww";
    };
  };

  config = lib.mkIf config.keke.fcitx5.enable {
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
        Description = "eww; ElKowars wacky widgets ";
        After = [ "graphical-session.target" ];
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
      Service = {
        Restart = "on-failuer";
        ExecStart = "${pkgs.eww}/bin/eww daemon --no-daemonize";
      };
    };
  };
}
