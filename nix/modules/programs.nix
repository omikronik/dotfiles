# General programs in here
{
  config,
  pkgs,
  inputs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    firefox
    brave
    anki-bin
    discord
    inputs.zen-browser.packages."${pkgs.system}".twilight
    thunderbird
    ffmpeg
    mpv
    wget
    unar
    unzip
    htop
    btop
    radeontop
    nvtopPackages.amd
    kitty
  ];
}
