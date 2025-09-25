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
        codex = "~/.local/lib/bin/codex";
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

    pua = import ./pua-bindings.nix { inherit lib; };
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
        ".config/ghostty/config".text = ''
            font-feature = -calt, -liga, -dlig
            shell-integration-features = no-cursor
            cursor-style = block
            cursor-style-blink = false
            cursor-text = #000000
            cursor-color = #46D9A8
            mouse-hide-while-typing = true
            background = #000000
            foreground = #B4B3B5
            # font-thicken = true
            # font-thicken-strength = 255
            font-size = 16
            window-padding-balance = false
            macos-titlebar-proxy-icon = hidden

            keybind = cmd+h=goto_split:left
            keybind = cmd+j=goto_split:down
            keybind = cmd+k=goto_split:up
            keybind = cmd+l=goto_split:right
        '';
    } else {};

    home.sessionVariables = {
        EDITOR = "nvim";
    };

    programs.fzf.enable = true;
    programs.yazi.enable = true;

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

            set -g status-interval 1

            set -g renumber-windows on

            set -g status-position top
            set -g status-justify absolute-centre

            set -g message-style "bg=color88,fg=white"
            set -g mode-style "bg=color88,fg=white"

            set -g pane-border-style "fg=#063540"
            set -g pane-active-border-style "fg=#268bd3"

            set -g @FG_COLOR "#E6E6E7"
            set -g @BG_COLOR "#2F2F2F"

            set-option -g status-style 'bg=#{@BG_COLOR},fg=#{@FG_COLOR}'
            set -g window-status-current-style 'bg=#545454,fg=#{@FG_COLOR}'
            set -g window-status-format ' #I:(#{pane_current_command} #(p="#{pane_current_path}"; [ "$p" = "$HOME" ] && echo "~" || basename "$p")) '
            set -g window-status-current-format ' #I:(#{pane_current_command} #(p="#{pane_current_path}"; [ "$p" = "$HOME" ] && echo "~" || basename "$p")) '

            set -g status-left ' #S '
            set -g status-right ' #h '
        '' + pua.tmuxExtra;
    };

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
            keyboard.bindings = pua.alacrittyBindings;
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
