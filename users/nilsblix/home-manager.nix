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
        nvim = "~/neovim-flake/result/bin/nvim";
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

    home.packages = [
        pkgs.git
        pkgs.gh
        pkgs.ripgrep
        pkgs.tree
        pkgs.tmux

        pkgs.fd
        pkgs.dust

        pkgs.firefox
        pkgs.discord
        pkgs.dbgate
        pkgs.postman
    ] ++ (if isDarwin then [
        pkgs.ghostty-bin
        pkgs.sioyek
    ] else [
        pkgs.spotify
        pkgs.xclip
        pkgs.oversteer
        pkgs.linuxHeaders
        pkgs.heroic
    ]);

    home.file = {
        ".config/ghostty/config".text = ''
            font-feature = -calt, -liga, -dlig

            background = #000000
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
            # macos-titlebar-style = tabs
            macos-titlebar-style = native

            keybind = cmd+k=goto_split:top
            keybind = cmd+j=goto_split:bottom
            keybind = cmd+h=goto_split:left
            keybind = cmd+l=goto_split:right
        '';
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
            nnoremap <Esc> :silent! nohlsearch<CR><Esc>
        '';
    } // (if isDarwin then {
            ".config/karabiner/karabiner.json".source = ./karabiner.json;
        } else {});

    home.sessionVariables = {
        EDITOR = "vim";
    };

    programs.fzf.enable = true;
    programs.yazi.enable = true;
    programs.alacritty.enable = true;

    programs.direnv = {
        enable = true;
        silent = true;
        nix-direnv.enable = true;
    };

    programs.zsh = {
        enable = true;
        shellAliases = shellAliases "zsh";
        initContent = lib.concatStrings [ ''
            eval "$(${inputs.glowstick.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/main zsh fish)"
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
            url."git@github.com:nilsblix/".insteadOf = "https://github.com/nilsblix/";
            url."git@github.com:nilsblix/".pushInsteadOf = "https://github.com/nilsblix/";
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
