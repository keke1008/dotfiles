{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.keke.package = {
    packageGroups = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [ "cui-development" ];
      description = "List of package groups to be installed.";
    };
  };

  config = lib.mkIf (lib.length config.keke.package.packageGroups > 0) {
    home.packages =
      let
        packageGroupDefinitions = {
          cui-development = with pkgs; [
            bat
            delta
            eza
            fish
            fzf
            gcc
            gh
            git
            jq
            neovim
            ripgrep
            tmux
            tree
            vim
          ];

          nixos-development = with pkgs; [
            nil
            nixfmt-rfc-style
          ];

          gui-development = with pkgs; [
            _1password-gui
            alacritty
            firefox
            vscode
            wl-clipboard
          ];
        };

        mapPackageGroup =
          groupName:
          packageGroupDefinitions.${groupName} or (builtins.throw "Unknown package group: ${groupName}");
      in
      lib.flatten (builtins.map mapPackageGroup config.keke.package.packageGroups);
  };
}
