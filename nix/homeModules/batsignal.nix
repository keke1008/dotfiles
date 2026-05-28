{
  lib,
  config,
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
    services.batsignal = {
      enable = true;
      extraArgs = lib.strings.splitString " " "-w 20 -c 10";
    };
  };
}
