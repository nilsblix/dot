{ ... }:
{
    flake.modules.darwin.packages = { pkgs, ... }: {
        environment.systemPackages = with pkgs; [
            btop
            nixd
            pam-reattach
            vim
            wget
            zsh
        ];
    };

    flake.modules.homeManager.packages = { pkgs, ... }: {
        home.packages = with pkgs; [
            dbgate
            discord
            dust
            fd
            firefox
            gh
            git
            postman
            ripgrep
            tmux
            tree
        ] ++ (if pkgs.stdenv.isDarwin then [
            ghostty-bin
            sioyek
        ] else [
            heroic
            linuxHeaders
            oversteer
            spotify
            xclip
        ]);
    };

    flake.modules.nixos.packages = { pkgs, ... }: {
        environment.systemPackages = with pkgs; [
            btop
            neofetch
            nixd
            vim
            zsh
        ];
    };
}
