# Things related to Hyprland and the desktop experience
{
  config,
  pkgs,
  ...
}: {
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  environment.systemPackages = with pkgs; [
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
    uwsm

    # Audio
    pavucontrol
    pwvucontrol
  ];
}
