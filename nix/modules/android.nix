{
  config,
  pkgs,
  inputs,
  ...
}: {
  programs.adb.enable = true;
  users.users.yasir.extraGroups = ["adbusers", "kvm"];
}
