{ pkgs, ... }:
{
  config = {
    home.packages = [
      (pkgs.writeShellScriptBin "nixos" ''
        main() {
        	if [ "$#" -ne 1 ]; then
        		echo "Usage: $0 <switch | test>"
        		exit 1
        	fi

        	local action="$1"
        	if [ "$action" != "switch" ] && [ "$action" != "test" ]; then
        		echo "Invalid action: $action. Use 'switch' or 'test'."
        		exit 1
        	fi

        	local flake_path="$XDG_CONFIG_HOME/nixos"
        	exec sudo nixos-rebuild "$action" --flake "$flake_path"
        }

        main "$@"
      '')
    ];
  };
}
