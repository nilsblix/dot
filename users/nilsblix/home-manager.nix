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
        codex = "~/.local/lib/bin/codex";
    };

    nvimHabitScript = ''
        nvim() {
            if [ -d "$1" ]; then
                echo "The dot is a trap. Don't go in there, warrior."
            else
                command nvim "$@"
            fi
        }
    '';

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
        # I hate this.
        zig_0_14

        # Overlays
        nvim-pkg
    ] ++ (if isDarwin then [
        chatgpt
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
            background = #1E1E1E
            foreground = #D5D5D5
            # background = #000000
            # foreground = #B4B3B5
            font-size = 16
            window-padding-balance = false
            macos-titlebar-proxy-icon = hidden

            keybind = cmd+h=goto_split:left
            keybind = cmd+j=goto_split:down
            keybind = cmd+k=goto_split:up
            keybind = cmd+l=goto_split:right
        '';
        ".vimrc".text = ''
            filetype plugin indent on
            syntax on

            set ai
            set et
            set shiftwidth=4
            set tabstop=4
            set nowrap
            set sta
            set incsearch
            set hlsearch
            set scrolloff=10
            set autoread
            set noswapfile
            set mouse=a
            set clipboard+=unnamed
            set path+=**

            if executable("rg")
                set grepprg=rg\ --vimgrep\ --no-heading
            endif
            set grepformat=%f:%l:%c%m
            command! -nargs=+ -complete=file -bar Grep silent grep <args>|cope|redraw!

            let g:mapleader = " "
            nnoremap <leader>sf :find 
            nnoremap <leader>sg :Grep 
            nnoremap <leader>n :Ex<CR>
            nnoremap <leader>p <C-^>
            nnoremap <C-c> :cnext<CR>
            nnoremap <C-k> :cprev<CR>
            nnoremap <silent><Esc> :nohlsearch<CR>
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
                # prompt="$(PROMPT_SHELL_TYPE=zsh ${inputs.rusty-prompt.packages.${pkgs.system}.default}/bin/prompt)"
                prompt="$(CAMEL_SHELL_TYPE=zsh ${inputs.camel-prompt.packages.${pkgs.system}.default}/bin/main)"
                # prompt="$(CAMEL_SHELL_TYPE=zsh ~/code/camel-prompt/result/bin/main)"
            }
        '' yaziCdScript nvimHabitScript ];
    };

    programs.bash = {
        enable = true;
        shellAliases = shellAliases "bash";
        initExtra = lib.concatStrings [ ''
            # PS1="$(PROMPT_SHELL_TYPE=bash ${inputs.rusty-prompt.packages.${pkgs.system}.default}/bin/prompt)"
            PS1="$(CAMEL_SHELL_TYPE=bash ${inputs.camel-prompt.packages.${pkgs.system}.default}/bin/main)"
        '' yaziCdScript nvimHabitScript ];
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
