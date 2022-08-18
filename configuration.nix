{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  time.timeZone = "Europe/Berlin";

  i18n.defaultLocale = "en_US.UTF-8";

  # services.xserver.enable = true;
  # services.xserver.layout = "eu";

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  users.users.kiosk = {
    isNormalUser = true;
    # extraGroups = [ "wheel" ];
    packages = with pkgs; [
      firefox
    ];
    hashedPassword = "$6$t6UIxVslKgiwDGlH$p4GRNXx2SWqFUjc0ifiGi0bq7EBTGkIA/.EJnTxc13AelwJnLAPBAvnIxbgUJs/RfE4NUGwRwlEFqGO9BH.rr/";
  };

  documentation.enable = false;

  environment.systemPackages = with pkgs; [
    neovim
    wget
  ];

  # programs.sway.enable = true;
  services.cage = {
    enable = true;
    user = "kiosk";
  };
  services.openssh.enable = true;
  system.stateVersion = "22.05";
}

