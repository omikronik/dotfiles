# Things related to a KDE setup
{ config, pkgs, ...}:

{
	services.desktopManager.plasma6.enable = true;

	environment.systemPackages = with pkgs; [
		kdePackages.xdg-desktop-portal-kde
		kdePackages.kate
		slurp
		grim
	];
}
