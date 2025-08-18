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
		vulkan-tools
	];
}
