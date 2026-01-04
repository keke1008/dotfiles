{
  config,
  lib,
  ...
}:
{
  options.keke.kanata = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable kanata";
    };
  };

  config = lib.mkIf config.keke.kanata.enable {
    users.users = lib.genAttrs config.keke.trustedUserNames (_: {
      extraGroups = [
        "input"
        "uinput"
      ];
    });

    hardware.uinput.enable = true;

    services.udev.extraRules = ''
      KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"
    '';
  };
}
