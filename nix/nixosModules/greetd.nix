{
  config,
  pkgs,
  ...
}:
{
  options.keke.greetd = {
    enable = pkgs.lib.mkOption {
      type = pkgs.lib.types.bool;
      default = false;
      description = "Enable greetd";
    };
  };

  config = pkgs.lib.mkIf config.keke.greetd.enable {
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          user = "greeter";
          command =
            let
              launchUWSM = pkgs.writeShellApplication {
                name = "launch_uwsm";
                runtimeInputs = with pkgs; [ uwsm ];
                text = ''
                  if uwsm check may-start -iv && uwsm select; then
                    uwsm start default
                  fi
                '';
              };
              tuigreetBin = "${pkgs.tuigreet}/bin/tuigreet";
              launchUWSMBin = "${launchUWSM}/bin/launch_uwsm";
            in
            "${tuigreetBin} --time --remember --remember-user-session --cmd ${launchUWSMBin}";
        };
      };
    };
  };
}
