{
  description = "Framework nix config flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
  };

  outputs = {
    self,
    nixpkgs,
    zen-browser,
    ...
  } @ inputs: let
    system = "x86_64-linux";
  in {
    nixosConfigurations = {
      tora = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs;};
        modules = [
          ./configuration.nix
          ../modules/hyprland.nix
          ../modules/shared_desktop.nix
          ../modules/development.nix
          ../modules/programs.nix
          ../modules/gpu.nix
          ../modules/steam.nix
          ../modules/gaming.nix
        ];
      };
    };
  };
}
