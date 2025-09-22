{ pkgs, ... }:
{
    # As of sept 2024 macOS this is the current version
    system.stateVersion = 5;
    ids.gids.nixbld = 350;

    nix = {
        extraOptions = ''
            experimental-features = nix-command flakes
        '';
    };

    programs.zsh.enable = true;

    environment.systemPackages = with pkgs; [
        zsh
        vim
        btop
        neofetch
        pam-reattach
    ];

    networking = {
        computerName = "Nilss Macbook Pro 14";
        hostName = "macos"; # this changes the one inside tmux
        localHostName = "mp14-darwin";
    };

    security.pam.services.sudo_local = {
        touchIdAuth = true;
        reattach = true;
    };
}
