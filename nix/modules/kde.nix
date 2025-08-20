# Things related to a KDE setup
{
  config,
  pkgs,
  ...
}: {
  services.desktopManager.plasma6.enable = true;

  environment.variables = {
    # some apps dont like integrated + discreet and default to integrated
    # this should fix that
    DRI_PRIME = "1";
    __GLX_VENDOR_LIBRARY_NAME = "mesa";
    __EGL_VENDOR_LIBRARY_FILENAMES = "/run/opengl-driver/share/glvnd/egl_vendor.d/50_mesa.json";
  };

  environment.systemPackages = with pkgs; [
    kdePackages.xdg-desktop-portal-kde
    kdePackages.kate
    slurp
    grim
  ];
}
