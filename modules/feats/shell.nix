{ inputs, ... }:
{
    flake.modules.darwin.shell = {
        programs.zsh.enable = true;
    };

    flake.modules.homeManager.shell = { lib, pkgs, ... }:
    let
        shellAliases = shell: {
            c = "cd $(fd --type=dir | fzf)";
            codex = "nix run github:numtide/llm-agents.nix#codex";
            da = "direnv allow";
            drs = "sudo darwin-rebuild build switch --flake";
            gd = "git diff";
            gs = "git status";
            ll = "ls -l";
            ls = "ls --color=tty";
            nd = "nix develop -c " + shell;
            nrs = "sudo nixos-rebuild switch --flake";
            nvim = "~/neovim-flake/result/bin/nvim";
        };

        glowstick =
            inputs.nilsblix-glowstick.packages.${pkgs.stdenv.hostPlatform.system}.default;

        yaziCdScript = ''
            function y() {
                local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
                yazi "$@" --cwd-file="$tmp"
                IFS= read -r -d "" cwd < "$tmp"
                [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
                rm -f -- "$tmp"
            }
        '';
    in {
        programs.zsh = {
            enable = true;
            shellAliases = shellAliases "zsh";
            initContent = lib.concatStrings [
                ''
                    eval "$(${glowstick}/bin/main zsh anyhow)"
                ''
                yaziCdScript
            ];
        };
    };

    flake.modules.nixos.shell = {
        programs.zsh.enable = true;
    };
}
