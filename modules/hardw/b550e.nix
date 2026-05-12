{ ... }:
{
    flake.modules.nixos.hardware-b550e = { config, lib, modulesPath, ... }: {
        imports = [
            (modulesPath + "/installer/scan/not-detected.nix")
        ];

        boot.initrd.availableKernelModules = [
            "nvme"
            "xhci_pci"
            "ahci"
            "usbhid"
            "usb_storage"
            "sd_mod"
        ];
        boot.initrd.kernelModules = [];
        boot.kernelModules = [
            "kvm-amd"
        ];
        boot.extraModulePackages = [];

        fileSystems."/" = {
            device = "/dev/disk/by-uuid/ab71b262-f912-4025-ad65-4582dc5d733d";
            fsType = "ext4";
        };

        fileSystems."/boot" = {
            device = "/dev/disk/by-uuid/9A65-1209";
            fsType = "vfat";
            options = [
                "fmask=0022"
                "dmask=0022"
            ];
        };

        hardware.cpu.amd.updateMicrocode =
            lib.mkDefault config.hardware.enableRedistributableFirmware;

        networking.useDHCP = lib.mkDefault true;

        swapDevices = [
            {
                device = "/dev/disk/by-uuid/9e655f6e-7fb9-4169-a9cd-23069437d069";
            }
        ];
    };
}
