{ pkgs, ... }:

{
    time.timeZone = "Europe/Stockholm";

    console.keyMap = "sv-latin1";

    services.xserver = {
        enable = true;
        xkb.layout = "se";
        xkb.options = "caps:escape,lv3:lalt_switch";
        xkb.variant = "mac";
        videoDrivers = [ "nvidia" ];
    };

    services.displayManager.sddm.enable = true;
    services.desktopManager.plasma6.enable = true;

    # Logitech g923 drivers. https://discourse.nixos.org/t/gaming-logitech-g-923-not-working/47144
    hardware.new-lg4ff.enable = true;
    services.udev.packages = with pkgs; [ oversteer ];

    # https://nixos.wiki/wiki/Steam
    programs.steam = {
        enable = true;
        remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
        dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
        localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    };

    imports = [
        ./fonts.nix
    ];

    users.users.nilsblix = {
        isNormalUser = true;
        extraGroups = [ "wheel" ];
        shell = pkgs.zsh;
    };
}
