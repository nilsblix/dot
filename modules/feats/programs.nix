{ ... }:
{
    flake.modules.homeManager.programs = {
        home.sessionVariables.EDITOR = "vim";

        programs.alacritty.enable = true;
        programs.direnv = {
            enable = true;
            nix-direnv.enable = true;
            silent = true;
        };
        programs.fzf.enable = true;
        programs.yazi.enable = true;
    };
}
