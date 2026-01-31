{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.keke.batsignal = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable batsignal";
    };
  };

  config = lib.mkIf config.keke.batsignal.enable {
    systemd.user.services.batsignal = {
      Unit = {
        Description = "Battery monitor daemon";
        After = [ "graphical-session.target" ];
      };

      Service = {
        ExecStart = "${pkgs.batsignal}/bin/batsignal -f 80 -w 20 -c 10";
        Restart = "on-failure";
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
