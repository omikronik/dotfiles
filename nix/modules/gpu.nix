{ config, pkgs, ... }:
{
	boot.initrd.kernelModules = [ "amdgpu" ];

	hardware = {
		graphics = {
			enable = true;
			enable32Bit = true;
		};
	};

	environment.systemPackages = with pkgs; [
		mesa
		mesa-gl-headers
		libgbm
		vulkan-tools
		libva
		libva-utils
		libvdpau-va-gl
		libGL
		libGLU
		libglvnd
	];
}
