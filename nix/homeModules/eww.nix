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
  };
}
