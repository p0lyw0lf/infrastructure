{ ... }:
{
  disko.devices.disk.disk1.device = "/dev/vda";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
}
