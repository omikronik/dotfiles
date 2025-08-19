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
		ffmpeg
		mpv
		wget
		unar
		unzip
		htop
		btop
		radeontop
		nvtopPackages.amd
		kitty
	];
}
