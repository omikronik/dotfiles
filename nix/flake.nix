{
	description = "Framework nix config flake";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
		zen-browser.url = "github:0xc000022070/zen-browser-flake";
	};

	outputs = { self, nixpkgs, zen-browser, ... }:
		let
			system = "x86-64-linux";
		in
		{
			nixosConfigurations = {
				nixos = nixpkgs.lib.nixosSystem {
					inherit system;
					modules = [
						./configuration.nix
						./modules/hyprland.nix
					];
				};
			};
		};
}
