{ config, ... }:
let
    inherit (config.flake.modules) nixos;
in {
    configurations.nixos.nixos.module.imports = [
        nixos.host-b550e
        nixos.nix
        nixos.nilsblix
        nixos.fonts
        nixos.packages
        nixos.shell
        nixos.desktop
        nixos.gaming
        nixos.home-manager
    ];

    flake.modules.nixos.host-b550e = { config, ... }: {
        imports = [
            nixos.hardware-b550e
        ];

        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;

        hardware.bluetooth = {
            enable = true;
            powerOnBoot = true;
        };

        hardware.graphics.enable = true;
        hardware.nvidia = {
            modesetting.enable = true;
            nvidiaSettings = true;
            open = true;
            package = config.boot.kernelPackages.nvidiaPackages.stable;
        };

        networking.hostName = "nixos";
        networking.networkmanager.enable = true;

        nixpkgs.hostPlatform = "x86_64-linux";
        system.stateVersion = "24.11";
    };
}
