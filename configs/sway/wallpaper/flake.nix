{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { nixpkgs, flake-utils, ... }:

    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        python = pkgs.python3.withPackages (
          ps: with ps; [
            numpy
            scipy
            pillow
          ]
        );

        wallpaper = pkgs.runCommand "wallpaper" { nativeBuildInputs = [ python ]; } ''
          mkdir -p $out
          python ${./main.py} "$out/wallpaper.png"
        '';
      in
      {
        packages.default = wallpaper;

        apps.default = {
          type = "app";
          program = toString (
            pkgs.writeShellScript "deploy" ''
              cp --no-preserve=mode ${wallpaper}/wallpaper.png ../sway/wallpaper.png
            ''
          );
        };

        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            python
            ruff
            pyright
          ];
        };

      }
    );
}
