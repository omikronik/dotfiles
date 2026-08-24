{
  config,
  pkgs,
  inputs,
  ...
}: {
  programs.virt-manager.enable = true;
  users.groupd.libvirtd.members = ["yasir"];
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
}
