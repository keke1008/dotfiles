{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.keke.sway = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable sway window manager";
  };

  config = lib.mkIf config.keke.sway.enable {
    home.packages = with pkgs; [
      dunst
      grim
      hyprpolkitagent
      sway
      swayidle
      swaylock
      uwsm # For executing `uwsm finalize` in sway config
      waybar
      wmenu

      # The `sway.desktop` file that comes with the sway package uses a command name (`sway`) in the Exec field.
      # Therefore, it cannot be executed in environments where the PATH variable is not set up correctly.
      # This custom desktop entry ensures that the Exec path is absolute.
      # See: https://github.com/swaywm/sway/blob/dbe86400357fb1d41693874f7d9f70f285fd1737/sway.desktop
      (pkgs.writeTextFile {
        name = "sway-absolute-path.desktop";
        destination = "/share/wayland-sessions/sway-absolute-path.desktop";
        text = ''
          [Desktop Entry]
          Name=Sway Absolute Path
          Comment=An absolute path version of Sway
          Exec=${pkgs.sway}/bin/sway
          Type=Application
          DesktopNames=sway-absolute-path
        '';
      })
    ];
  };
}
