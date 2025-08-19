# General programs in here
{ config, pkgs, inputs, ... }:

{
	environment.systemPackages = with pkgs; [
		firefox
		brave
		anki-bin
		webcord
		inputs.zen-browser.packages."${pkgs.system}".default
		thunderbird

		kdePackages.gwenview
		kdePackages.dolphin
		kdePackages.breeze
		kdePackages.breeze-icons
		mpv
	];
}
