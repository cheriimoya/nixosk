{ pkgs, lib, ... }:
let
  installScript = pkgs.writeScriptBin "trigger-system-installation" ''
    #!/bin/sh
    # Partition and format a given device

    set -euo pipefail

    if [ $# -ne 2 ]; then
        echo "Please provide device to use and its type"
        exit 1
    fi

    DEVICE="$2"

    echo "> Using $DEVICE"

    sudo fdisk "$DEVICE" <<EOF
    g
    n
    1

    +1G
    t
    1
    n
    2

    +8G
    t
    2
    19
    n
    3


    w
    EOF

    if [ "$1" == "-n" ]; then
      sudo mkfs.fat -F32 -n BOOT "''${DEVICE}p1"
      sudo mkswap -L SWAP "''${DEVICE}p2"
      sudo mkfs.xfs -f -m bigtime=1 -L ROOT "''${DEVICE}p3"
    fi

    if [ "$1" == "-s" ]; then
      sudo mkfs.fat -F32 -n BOOT "''${DEVICE}1"
      sudo mkswap -L SWAP "''${DEVICE}2"
      sudo mkfs.xfs -f -m bigtime=1 -L ROOT "''${DEVICE}3"
    fi

    while ! test -e "/dev/disk/by-label/ROOT"; do
      sleep 1
    done

    while ! test -e "/dev/disk/by-label/SWAP"; do
      sleep 1
    done

    while ! test -e "/dev/disk/by-label/BOOT"; do
      sleep 1
    done

    sudo mount /dev/disk/by-label/ROOT /mnt
    sudo mkdir /mnt/boot
    sudo mount /dev/disk/by-label/BOOT /mnt/boot
    sudo swapon /dev/disk/by-label/SWAP

    sudo mkdir -p /mnt/etc/nixos
    sudo cp ${./configuration.nix} /mnt/etc/nixos/configuration.nix
    sudo cp ${./hardware-configuration.nix} /mnt/etc/nixos/hardware-configuration.nix

    sudo nixos-install

    echo "Installation done, please remove installation medium."
    for i in {10..1}; do
      echo "Will reboot in $i seconds"
      sleep 1
    done
    echo "Rebooting..."
    reboot
  '';
in {
  imports = [ <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-base.nix> ];

  environment.systemPackages = [ installScript ];

  services.getty.helpLine = lib.mkForce ''
    Run trigger-system-installation <-n|-s> <path-to-your-device>, e.g.

    For nvme disks
        trigger-system-installation -n /dev/nvme0n1

    For sata disks
        trigger-system-installation -s /dev/sda
  '';

  isoImage.edition = "kiosk";
  fonts.fontconfig.enable = false;
}
