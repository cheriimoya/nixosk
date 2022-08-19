# NixOSk

This project helps you to generate an iso installer including an install script that sets up a kiosk mode firefox running on a customer-facing touchscreen.
It uses [cage](https://github.com/Hjdskes/cage) to launch a firefox private window with a specified URL.

To generate the iso file run `nix-build -A config.system.build.isoImage -I nixos-config=iso.nix '<nixpkgs/nixos>'` in the root of this project.
The iso will be available at `./result/iso/nixos-...-x86_64-linux.iso`.

You can `dd` the iso to a USB drive by issuing `sudo dd status=progress if=./result/iso/nixos-...-x86_64-linux.iso of=/dev/sdX bs=1M`.

When booting from the USB drive, select the copytoram option in the boot menu.
Then, after you have an interactive tty, run `trigger-system-installation -s /dev/sda` if you want to install on a sata drive or `trigger-system-installation -n /dev/nvme0n1` if NixOSk should be installed to a nvme device.

The installation script will
1. partition the given device (:warning: data will be lost!)
2. format the partitions
4. mount the partitions
5. copy over the configuration.nix and hardware-configuration.nix files
5. trigger a normal `nixos-install`
6. reboot

During installation, you will be asked to supply a root password.

After the reboot the installation medium can be removed and the system should boot into the NixOSk installation, immediately launching the firefox browser.
Switching to other ttys is not enabled, however, an ssh server is running.
