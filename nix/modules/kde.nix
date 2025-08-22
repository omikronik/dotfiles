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

  environment.systemPackages = with pkgs; [
    kdePackages.xdg-desktop-portal-kde
    kdePackages.kate
    slurp
    grim

    extest
  ];
}
