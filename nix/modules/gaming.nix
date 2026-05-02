{ config, pkgs, ... }:
let
  lutris-fixed = pkgs.lutris.override {
    buildFHSEnv = args: pkgs.buildFHSEnv (args // {
      multiPkgs = envPkgs:
        let
          originalPkgs = args.multiPkgs envPkgs;
          customLdap = envPkgs.openldap.overrideAttrs (_: { doCheck = false; });
        in
        builtins.filter (p: (p.pname or "") != "openldap") originalPkgs ++ [ customLdap ];
    });
  };
in
{
  environment.variables = {
    WINEDEBUG = "-all";
    WINEPREFIX = "$HOME/.wine";
    QT_QPA_PLATFORMTHEME = "kde";
  };
  environment.systemPackages = with pkgs; [
    winetricks
    wineWow64Packages.waylandFull
    lutris-fixed
    dxvk
    vkd3d-proton
  ];
}
