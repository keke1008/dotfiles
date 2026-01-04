{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells = {
          default = pkgs.mkShell {
            packages = with pkgs; [
              bash-language-server
              lua-language-server
              luajitPackages.luacheck
              nil
              biome
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
          initialize = pkgs.mkShell {
            packages = with pkgs; [
              curl
              fish
              git
              neovim
              tmux
              zsh
            ];
          };
        };
      }
    )
    // {
      nixosModules = ./nix/nixosModules;
    };
}
