{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { nixpkgs, ... }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];
      lib = nixpkgs.lib;
      forAllSystems = f: lib.genAttrs systems (system: f nixpkgs.legacyPackages."${system}");
    in
    {
      nixosModules = ./nix/nixosModules;
      homeModules = ./nix/homeModules;

      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          packages = with pkgs; [
            bash-language-server
            bats
            lua-language-server
            luajitPackages.luacheck
            nil
            biome
            kdePackages.qtdeclarative # for qmlls
            selene
            shellcheck
            shfmt
            stylua
            taplo
            typescript-language-server
            typescript # for typescript-language-server
            vscode-json-languageserver
          ];
        };

        initialize-script-requirements = pkgs.mkShell {
          packages = with pkgs; [
            curl
            fish
            git
            neovim
            tmux
            zsh
          ];
        };
      });
    };
}
