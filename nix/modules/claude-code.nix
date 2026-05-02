{
  config,
  pkgs,
  ...
}: {
  nix.settings = {
    substituters = [ "https://claude-code.cachix.org" ];
    trusted-public-keys = [
      "claude-code.cachix.org-1:YeXf2aNu7UTX8Vwrze0za1WEDS+4DuI2kVeWEE4fsRk="
    ];
  };

  environment.systemPackages = with pkgs; [
    claude-code  # native binary (default, ~180MB self-contained)
    # claude-code-node  # alternative: Node.js 22 runtime
    # claude-code-bun   # alternative: Bun runtime
  ];
}
