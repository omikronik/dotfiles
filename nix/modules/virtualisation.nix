{
  config,
  pkgs,
  inputs,
  ...
}: {
  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = ["yasir"];
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  environment.systemPackages = with pkgs; [
    swtpm
  ];
}
