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

    programs.fzf.enable = true;

    # I have tried to use this, but I always resort back to using vim.
    # programs.zed-editor = {
    #     enable = true;
    #     extensions = [
    #         "nix"
    #         "zig"
    #     ];
    #     userSettings = {
    #         languages.Nix.language_servers = [ "nixd" "!nil" ];
    #         lsp.nixd.settings.nixd.nixpkgs.expr = "import <nixpkgs> { }";
    #         vim_mode = true;
    #         # Visual
    #         buffer_font_family = "Hack Nerd Font Mono";
    #         cursor_shape = "block";
    #         show_whitespaces = "trailing";
    #         toolbar = {
    #             breadcrumbs = false;
    #             quick_actions = false;
    #             selections_menu = false;
    #             agent_review = false;
    #             code_actions = false;
    #         };
    #         scrollbar.show = "never";
    #         minimap.show = "never";
    #         vertical_scroll_margin = 8; # Similar to my vim.
    #         tab_bar.show = false;
    #     };
    # };

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
