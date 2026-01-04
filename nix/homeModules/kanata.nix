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
    systemd.user.services.kanata = {
      Unit = {
        Description = "Kanata keyboard remapper";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
      Service = {
        Environment = "DISPLAY=:0";
        Type = "simple";
        Restart = "no";
        ExecStart = "${pkgs.kanata}/bin/kanata --cfg ${../../configs/kanata/config.kbd}";
      };
    };
  };
}
