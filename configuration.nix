{ config, pkgs, lib, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  hardware.enableAllFirmware = true;
  nixpkgs.config.allowUnfree = true;

  networking.hostName = "kiosk";

  time.timeZone = "Europe/Berlin";

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  users.users.kiosk = {
    isNormalUser = true;
    # Generated via `mkpasswd -m sha-512`
    hashedPassword = "$6$hK0krpzTCXH3Yd.1$81czWYyv4U4aTcrMz0rRC7SDhTeIRZOzqxR1llmubr0orwR345ZlzhOxumSxAFupr2zLeSj/GTFX.kwr6Avyf1"; # ricardo.
  };

  documentation.enable = false;

  systemd.services."cage-tty1" = {
    after = [ "network-online.target" ];
    environment.MOZ_ENABLE_WAYLAND = "1";
    environment.MOZ_USE_XINPUT2 = "1";
    serviceConfig.Restart = "always";
    serviceConfig.ExecStart = lib.mkForce "${pkgs.cage}/bin/cage -- ${pkgs.firefox}/bin/firefox --private-window --kiosk https://beemobile.beethovenfest.de/de";
  };

  services.cage = {
    enable = true;
    user = "kiosk";
  };

  services.openssh.enable = true;
  system.stateVersion = "22.05";
}
