{ inputs, ... }:

{ lib, pkgs, ... }: let
    isDarwin = pkgs.stdenv.isDarwin;

    shellAliases = shell: {
        vim = "nvim";
        ls = "ls --color=tty";
        l = "ls -al";
        drs = "sudo darwin-rebuild build switch --flake";
        nrs = "sudo nixos-rebuild switch --flake";
        nd = "nix develop -c " + shell;
        gs = "git status";
        gd = "git diff";
        sesh = "~/.local/bin/sessionizer.sh";
    };

    yaziCdScript = ''
        function y() {
            local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
            yazi "$@" --cwd-file="$tmp"
            IFS= read -r -d "" cwd < "$tmp"
            [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
            rm -f -- "$tmp"
        }
    '';

    secretsFile = "${inputs.secrets}/secrets.nix";
    secrets = if builtins.pathExists secretsFile then import secretsFile else {};
in {
    home.username = "nilsblix";
    home.homeDirectory = if isDarwin then "/Users/nilsblix" else "/home/nilsblix";

    home.stateVersion = "25.05";

    programs.home-manager.enable = true;

    home.packages = with pkgs; [ # alphabetical order
        git
        gh
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

    programs.tmux = {
        enable = true;
        baseIndex = 1;
        prefix = "C-Space";
        disableConfirmationPrompt = true;
        customPaneNavigationAndResize = true;
        mouse = true;
        extraConfig = ''
            unbind r
            bind r source-file ~/.config/tmux/tmux.conf\; display-message "Config reloaded..."

            set -g status-position top

            bind -n "\uE001" select-window -t 1
            bind -n "\uE002" select-window -t 2
            bind -n "\uE003" select-window -t 3
            bind -n "\uE004" select-window -t 4
            bind -n "\uE005" select-window -t 5
            bind -n "\uE006" select-window -t 6
            bind -n "\uE007" select-window -t 7
            bind -n "\uE008" select-window -t 8
            bind -n "\uE009" select-window -t 9

            bind -n "\E0010" kill-window
        '';
    };

    programs.fzf.enable = true;

    programs.yazi.enable = true;

    programs.alacritty = {
        enable = true;
        settings = {
            env = {
                TERM = "xterm-256color";
            };
            font = {
                normal = {
                    family = "JetBrainsMono Nerd Font";
                };
                size = if isDarwin then 16 else 13;
            };
            window.dynamic_title = true;
            colors.primary.background = "#000000";
            colors.primary.foreground= "#B4B3B5";
            mouse = {
                hide_when_typing = true;
            };
            selection = {
                save_to_clipboard = true;
            };
            option_as_alt = "OnlyLeft";
            keyboard.bindings = [
                # https://docs.rs/winit/latest/winit/keyboard/enum.NamedKey.html
                { key = "Key1"; mods = "Command"; chars = "\\uE001"; }
                { key = "Key2"; mods = "Command"; chars = "\\uE002"; }
                { key = "Key3"; mods = "Command"; chars = "\\uE003"; }
                { key = "Key4"; mods = "Command"; chars = "\\uE004"; }
                { key = "Key5"; mods = "Command"; chars = "\\uE005"; }
                { key = "Key6"; mods = "Command"; chars = "\\uE006"; }
                { key = "Key7"; mods = "Command"; chars = "\\uE007"; }
                { key = "Key8"; mods = "Command"; chars = "\\uE008"; }
                { key = "Key9"; mods = "Command"; chars = "\\uE009"; }
                { key = "W"; mods = "Command"; chars = "\\uE0010"; }
            ];
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
        initContent = lib.concatStrings [ ''
            function precmd() {
                prompt="$(PROMPT_SHELL_TYPE=zsh ${inputs.prompt.packages.${pkgs.system}.default}/bin/prompt)"
            }
        '' yaziCdScript ];
    };

    programs.bash = {
        enable = true;
        shellAliases = shellAliases "bash";
        initExtra = lib.concatStrings [ ''
            PS1="$(PROMPT_SHELL_TYPE=bash ${inputs.prompt.packages.${pkgs.system}.default}/bin/prompt)"
        '' yaziCdScript ];
    };

    programs.git = {
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
