{
  config,
  lib,
  ...
}:
{
  options.keke.locale = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable custom locale configuration";
    };
  };

  config = lib.mkIf config.keke.locale.enable {
    time.timeZone = "Asia/Tokyo";

    i18n.defaultLocale = "en_US.UTF-8";

    console = {
      font = "Lat2-Terminus16";
      keyMap = "jp106";
    };
  };
}
