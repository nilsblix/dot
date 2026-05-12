{ ... }:
{
    flake.modules.nixos.gaming = { pkgs, ... }: {
        hardware.new-lg4ff.enable = true;
        services.udev.packages = with pkgs; [
            oversteer
        ];

        programs.steam = {
            enable = true;
            dedicatedServer.openFirewall = true;
            localNetworkGameTransfers.openFirewall = true;
            remotePlay.openFirewall = true;
        };
    };
}
