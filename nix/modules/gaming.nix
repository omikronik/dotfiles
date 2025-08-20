{ config, pkgs, ... }:

{
	environment.variables = {
		WINEDEBUG = "-all";
		WINEPREFIX = "$HOME/.wine";
	};

	environment.systemPackages = with pkgs; [
		winetricks
		wineWowPackages.waylandFull
		lutris
	];
}
