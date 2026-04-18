{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.keke.sway = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable sway window manager";
    };
  };

  config = lib.mkIf config.keke.sway.enable {
    xdg.portal = {
      enable = true;
      config.common.default = "*";
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };

    services.hyprpolkitagent.enable = true;

    home.packages = with pkgs; [
      grim
      libnotify
      sway
      swayidle
      swaylock
      swaynotificationcenter
      uwsm # For executing `uwsm finalize` in sway config
      waybar
      wmenu
      wofi
    ];
  };
}
