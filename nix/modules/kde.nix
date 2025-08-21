# Things related to a KDE setup
{
  config,
  pkgs,
  ...
}: {
  services.desktopManager.plasma6.enable = true;

  # Enable automatic login for the user.
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "yasir";

  environment.variables = {
    # some apps dont like integrated + discreet and default to integrated
    # this should fix that
    DRI_PRIME = "1";
    #    __EGL_VENDOR_LIBRARY_FILENAMES = "/run/opengl-driver/share/glvnd/egl_vendor.d/50_mesa.json";
    #__GLX_VENDOR_LIBRARY_NAME = "mesa";
    #__GL_SYNC_TO_VBLANK = "1";
    #__GL_THREADED_OPTIMIZATIONS = "1";
    #VK_LOADER_LAYERS_ENABLE = "*device_select*";
    #RADV_PERFTEST = "gpl";
    #MESA_GLTHREAD = "true";
  };

  environment.systemPackages = with pkgs; [
    kdePackages.xdg-desktop-portal-kde
    kdePackages.kate
    slurp
    grim

    extest
  ];
}
