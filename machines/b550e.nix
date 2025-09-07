{ config, pkgs, ... }:
{
    imports = [
        ./hardware/b550e.nix
    ];

    system.stateVersion = "24.11";
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    networking.hostName = "nixos";
    networking.networkmanager.enable = true;

    environment.systemPackages = with pkgs; [
        zsh
        vim
        btop
        neofetch
    ];

    programs.zsh.enable = true;

    # Enables opengl.
    hardware.graphics = {
        enable = true;
    };

    # Basic nvidia drivers.
    hardware.nvidia = {
        modesetting.enable = true;
        open = true;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.stable;
    };

    hardware.bluetooth = {
        enable = true;
        powerOnBoot = true;
    };

    nix = {
        extraOptions = ''
            experimental-features = nix-command flakes
        '';
    };
}
