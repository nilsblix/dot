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
        da = "direnv allow";
        codex = "nix run github:numtide/llm-agents.nix#codex";
        c = "cd $(fd --type=dir | fzf)";
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

    secretsFile = "${inputs.dot-private}/secrets.nix";
    secrets = if builtins.pathExists secretsFile then import secretsFile else {};
in {
    home.username = "nilsblix";
    home.homeDirectory = if isDarwin then "/Users/nilsblix" else "/home/nilsblix";

    home.stateVersion = "25.05";

    programs.home-manager.enable = true;

    home.packages = [ # alphabetical order
        pkgs.git
        pkgs.gh
        pkgs.ripgrep
        pkgs.tree

        pkgs.fd
        pkgs.dust

        pkgs.firefox
        pkgs.discord
        pkgs.dbgate
        pkgs.postman

        # Overlays
        pkgs.neovim-flake
    ] ++ (if isDarwin then [
            pkgs.chatgpt
        ] else [ # Is on NixOS instead.
                pkgs.spotify
                pkgs.xclip
                pkgs.oversteer
                pkgs.linuxHeaders
                pkgs.heroic
            ]);

    programs.fzf.enable = true;

    home.file = {
        ".config/ghostty/config".text = ''
            font-feature = -calt, -liga, -dlig

            background = #030303
            foreground = #B4B3B5
            font-size = 16

            shell-integration-features = no-cursor
            cursor-style = block
            cursor-color = #FFB96E
            cursor-opacity = 0.75
            cursor-style-blink = false
            cursor-click-to-move = true
            mouse-hide-while-typing = true
            window-padding-balance = false

            keybind = cmd+h=goto_split:left
            keybind = cmd+j=goto_split:down
            keybind = cmd+k=goto_split:up
            keybind = cmd+l=goto_split:right

            keybind = shift+enter=text:\n

            macos-titlebar-style = native
        '';
        ".vim/colors/hybrid.vim".source = ./hybrid.vim;
        ".vimrc".text = ''
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
            set laststatus=2

            set background=dark
            colorscheme hybrid

            highlight Comment ctermfg=green

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
            nnoremap <Esc><Esc> :silent! nohlsearch<CR>
        '';
    } // (if isDarwin then {
            ".config/karabiner/karabiner.json".source = ./karabiner.json;
        } else {});

    home.sessionVariables = {
        EDITOR = "nvim";
    };

    # programs.fzf.enable = true;
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

            bind h select-pane -L
            bind j select-pane -D
            bind k select-pane -U
            bind l select-pane -R

            set -g status-interval 1

            set -g renumber-windows on

            set -g status-position top
            set -g status-justify absolute-centre

            set -g message-style "bg=color88,fg=white"
            set -g mode-style "bg=color88,fg=white"

            set -g pane-border-style "fg=#063540"
            set -g pane-active-border-style "fg=#268bd3"

            set -g @FG_COLOR "#E6E6E7"
            set -g @BG_COLOR "default"

            set-option -g status-style 'bg=#{@BG_COLOR},fg=#{@FG_COLOR}'
            set -g window-status-format ' #I:#{pane_current_command} #(p="#{pane_current_path}"; [ "$p" = "$HOME" ] && echo "~" || basename "$p") '
            set -g window-status-style 'bg=#303030'
            set -g window-status-current-format ' #I:#{pane_current_command} #(p="#{pane_current_path}"; [ "$p" = "$HOME" ] && echo "~" || basename "$p") '
            set -g window-status-current-style 'bg=#545454,fg=#{@FG_COLOR}'

            set -g status-left ""
            set -g status-right ""
        '';
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
            eval "$(${inputs.glowstick.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/main zsh groovy)"
        '' yaziCdScript ];
    };

    programs.bash = {
        enable = true;
        shellAliases = shellAliases "bash";
        initExtra = lib.concatStrings [ ''
            eval "$(${inputs.glowstick.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/main bash groovy)"
        '' yaziCdScript ];
    };

    programs.git = {
        enable = true;

        settings = {
            user = {
                name = "nilsblix";
                email = secrets.personal_email;
            };

            # Old `extraConfig`.
            github.user = "nilsblix";
            credential.helper = "osxkeychain";
        };

        includes = [
            {
                condition = "gitdir:~/Code/kth/";
                contents = {
                    user = secrets.kth;
                };
            }
        ];
    };
}
