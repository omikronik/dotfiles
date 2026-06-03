{
  inputs,
  pkgs,
  ...
}: {
  nixpkgs.overlays = [
    inputs.claude-desktop.overlays.default
    inputs.claude-code.overlays.default
  ];

  nix.settings = {
    substituters = [ "https://claude-code.cachix.org" ];
    trusted-public-keys = [
      "claude-code.cachix.org-1:YeXf2aNu7UTX8Vwrze0za1WEDS+4DuI2kVeWEE4fsRk="
    ];
  };

  environment.systemPackages = with pkgs; [
    claude-code  # native binary (default, ~180MB self-contained)
    claude-desktop
  ];
}
