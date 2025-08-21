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
        amdvlk
        libva
        libvdpau-va-gl
        libGL
        libGLU
        libglvnd
        libgbm
      ];

      extraPackages32 = with pkgs.driversi686Linux; [
        mesa
        amdvlk
        libvdpau-va-gl
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    mesa-gl-headers
    vulkan-tools
    mesa-demos
    libva-utils
  ];
}
