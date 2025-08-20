{
  config,
  pkgs,
  ...
}: {
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  environment.variables = {
    EDITOR = "nvim";
    TERM = "kitty";
    BROWSER = "firefox";
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    MOZ_DBUS_REMOTE = "1";
    MOZ_WAYLAND_USE_VAAPI = "1";
    MOZ_USE_XINPUT2 = "1";
    GBM_BACKEND = "mesa-dri";
    EGl_PLATFORM = "wayland";
    
    MOZ_ACCELERATED = "1";
    MOZ_WEBRENDER = "1";
    MOZ_X11_EGL = "1";
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

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  environment.systemPackages = with pkgs; [
    xdg-desktop-portal
    wl-clipboard
    kdePackages.gwenview
    kdePackages.dolphin
    kdePackages.breeze
    kdePackages.breeze-icons
  ];
}
