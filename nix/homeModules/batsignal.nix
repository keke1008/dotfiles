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
    home.packages = with pkgs; [
      batsignal
    ];
  };
}
