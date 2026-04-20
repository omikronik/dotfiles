{ config, pkgs, ... }:

{
	environment.variables = {
		WINEDEBUG = "-all";
		WINEPREFIX = "$HOME/.wine";

		QT_QPA_PLATFORMTHEME = "kde";
	};

	environment.systemPackages = with pkgs; [
		winetricks
		wineWow64Packages.waylandFull
		lutris

		dxvk
		vkd3d-proton
	];
}
