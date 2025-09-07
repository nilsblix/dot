{ inputs, ... }:

{ lib, pkgs, ... }: let
    isDarwin = pkgs.stdenv.isDarwin;

    shellAliases = shell: {
        ls = "ls --color=tty";
        l = "ls -al";
        drs = "sudo darwin-rebuild build switch --flake";
        nrs = "sudo nixos-rebuild switch --flake";
        nd = "nix develop -c " + shell;
        gs = "git status";
        gd = "git diff";
        sesh = "~/.local/bin/sessionizer.sh";
    };
in {
    home.username = "nilsblix";
    home.homeDirectory = if isDarwin then "/Users/nilsblix" else "/home/nilsblix";

    home.stateVersion = "25.05";

    programs.home-manager.enable = true;

    home.packages = with pkgs; [ # alphabetical order
        git
        gh
        fzf
        ripgrep

        spotify
        firefox
        discord
        dbgate
        postman

        zig_0_14
        nodejs_24

        # Overlays
        nvim-pkg
    ] ++ (if isDarwin then [
        # Nothing at the moment.
    ] else [ # Is on NixOS instead.
        xclip
        oversteer
        linuxHeaders
        heroic
    ]);

    home.file = if isDarwin then {
        ".config/karabiner/karabiner.json".source = ./karabiner.json;
    } else {};

    home.sessionVariables = {
        EDITOR = "nvim";
    };

    programs.alacritty = {
        enable = true;
        settings = {
            env = {
                TERM = "xterm-256color";
            };
            font = {
                normal = {
                    family = "Hack Nerd Font Mono";
                };
                size = if isDarwin then 20 else 13;
            };
            colors.primary.background = "#000000";
            colors.primary.foreground= "#B4B3B5";
            mouse = {
                hide_when_typing = true;
            };
            selection = {
                save_to_clipboard = true;
            };
        };
    };

    programs.direnv = {
        enable = true;
        silent = true;
        nix-direnv.enable = true;
    };

    programs.zsh = {
        enable = true;
        shellAliases = shellAliases "zsh";
        initContent = lib.mkOrder 1000 ''
            function precmd() {
                prompt="$(PROMPT_SHELL_TYPE=zsh ${inputs.prompt.packages.${pkgs.system}.default}/bin/prompt)"
            }
        '';
    };

    programs.bash = {
        enable = true;
        shellAliases = shellAliases "bash";
        initExtra = ''
            PS1="$(PROMPT_SHELL_TYPE=bash ${inputs.prompt.packages.${pkgs.system}.default}/bin/prompt)"
        '';
    };

    programs.git = let
        secretsFile = "${inputs.secrets}/secrets.nix";
        secrets = if builtins.pathExists secretsFile then import secretsFile else {};
    in {
        enable = true;
        userName = "nilsblix";
        userEmail = secrets.personal_email;

        extraConfig = {
            github.user = "nilsblix";
            credential.helper = "osxkeychain";
        };

        includes = [
            {
                condition = "gitdir:~/code/kth/";
                contents = {
                    user = secrets.kth;
                };
            }
        ];
    };
}
