{
  config,
  pkgs,
  inputs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    qmk
  ];

  hardware.keyboard.qmk.enable = true;
}
