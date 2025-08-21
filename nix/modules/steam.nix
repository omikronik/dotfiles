{
  config,
  pkgs,
  inputs,
  ...
}: {
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    extest.enable = true;
    protontricks = {
      enable = true;
    };
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };

  # for games that are distributed as appimage
  programs.appimage = {
    enable = true;
    binfmt = true;
  };
}
