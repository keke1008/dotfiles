{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.keke.fcitx5 = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable fcitx5 input method framework";
    };
  };

  config = lib.mkIf config.keke.fcitx5.enable {
    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        waylandFrontend = true;
        addons = with pkgs; [
          fcitx5-mozc-ut
          fcitx5-gtk
        ];
      };
    };
  };
}
