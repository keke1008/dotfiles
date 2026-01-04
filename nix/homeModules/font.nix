{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.keke.font = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable custom font configuration";
    };
  };

  config = lib.mkIf config.keke.font.enable {
    home.packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      udev-gothic-nf
    ];

    fonts.fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [ "Noto Serif" ];
        sansSerif = [ "Noto Sans" ];
        monospace = [ "UDEV Gothic 35NFLG" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };
}
