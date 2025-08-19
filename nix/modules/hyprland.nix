# Things related to Hyprland and the desktop experience
{ config, pkgs, ... }:

{
	programs.hyprland = {
		enable = true;
		xwayland.enable = true;
	};

	services.displayManager.sddm = {
		enable = true;
		wayland.enable = true;
	};

	environment.variables = {
		EDITOR="nvim";
		TERM="kitty";
		BROWSER="firefox";
	};

	environment.sessionVariables = {
		NIXOS_OZONE_WL = "1";
		MOZ_ENABLE_WAYLAND = "1";
		MOZ_WAYLAND_USE_VAAPI = "1";
		MOZ_USE_XINPUT2 = "1";
	};

	services.displayManager.defaultSession = "hyprland";

	security.rtkit.enable = true;
	services.pipewire = {
		enable = true;
		alsa.enable = true;
		pulse.enable = true;
	};

	fonts = {
		enableDefaultPackages = true;
		packages = with pkgs; [
			nerd-fonts.fira-code
			liberation_ttf
			corefonts
			carlito
			caladea

			noto-fonts
			noto-fonts-cjk-sans
			noto-fonts-cjk-serif
			noto-fonts-color-emoji
			noto-fonts-emoji-blob-bin

		];
	};

	environment.systemPackages = with pkgs; [
		# Desktop portals
		xdg-desktop-portal
		xdg-desktop-portal-hyprland

		# Wayland/Hyprland utils
		waybar
		wofi
		kitty
		hyprpaper
		hyprpicker
		hyprpolkitagent
		slurp
		grim
		dunst
		power-profiles-daemon
		brightnessctl
		wl-clipboard
		uwsm

		# Audio
		pavucontrol
		pwvucontrol
	];
}
