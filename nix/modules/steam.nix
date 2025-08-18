{ config, pkgs, inputs, ... }:

{
	programs.steam = {
		enable = true;
		remotePlay.openFirewall = true;
		dedicatedServer.openFirewall = true;
		localNetworkGameTransfers.openFirewall = true;
	};

	# for games that are distributed as appimage
	programs.appimage = {
		enable = true;
		binfmt = true;
	};

}
