{
  config,
  lib,
  ...
}:
{
  options.keke.swaylock = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable custom swaylock configuration";
    };
  };

  config = lib.mkIf config.keke.swaylock.enable {
    security.pam.services.swaylock = { };
  };
}
