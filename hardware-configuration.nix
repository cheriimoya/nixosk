# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usbhid" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/0cfa6aac-bdb7-4e8e-a54e-7563076d165a";
      fsType = "xfs";
    };

  fileSystems."/nix" =
    { device = "/dev/disk/by-uuid/77bab9e5-c9bb-4cb3-b754-78f28517ffde";
      fsType = "xfs";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/7752-A5D2";
      fsType = "vfat";
    };

  fileSystems."/home" =
    { device = "schoenbuch/home";
      fsType = "zfs";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/56301679-81fa-499f-b1af-af5e0d4a8b5f"; }
    ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.br-867b96b39f73.useDHCP = lib.mkDefault true;
  # networking.interfaces.br-c1346f5a45ed.useDHCP = lib.mkDefault true;
  # networking.interfaces.br-daaf467ce2d1.useDHCP = lib.mkDefault true;
  # networking.interfaces.docker0.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp0s31f6.useDHCP = lib.mkDefault true;
  # networking.interfaces.virbr0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wg0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wg1.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp3s0.useDHCP = lib.mkDefault true;

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
