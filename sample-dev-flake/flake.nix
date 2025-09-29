{
  description = "workout tracker app";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
};

outputs = { self, nixpkgs, flake-utils }:
  flake-utils.lib.eachDefaultSystem (system:
  let
    pkgs = nixpkgs.legacyPackages.${system};
  in
    {
    devShells.default = pkgs.mkShell {
      buildInputs = with pkgs; [
        fish
      ];

      shellHook = ''
        exec fish
      '';

      # Load any software packages
      #LD_LIBRARY_PATH = "${pkgs.SDL2}.lib";
    };
  });
  }
