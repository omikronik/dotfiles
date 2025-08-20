{
  config,
  pkgs,
  ...
}: {
  boot.initrd.kernelModules = ["amdgpu"];

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;

      extraPackages = with pkgs; [
        mesa
        libva
        libva-utils
        libvdpau-va-gl
        libGL
        libGLU
        libglvnd
        libgbm
      ];

      extraPackages32 = with pkgs.driversi686Linux; [
        mesa
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    mesa-gl-headers
    vulkan-tools
    mesa-demos
  ];
}
