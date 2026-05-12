{ config, ... }:
{
    flake.modules.nixos.nilsblix = { pkgs, ... }: {
        users.users.${config.username} = {
            isNormalUser = true;
            extraGroups = [ "wheel" ];
            shell = pkgs.zsh;
        };
    };

    flake.modules.darwin.nilsblix = { pkgs, ... }: {
        system.primaryUser = config.username;
        users.knownUsers = [
            config.username
        ];
        users.users.${config.username} = {
            uid = 501;
            home = "/Users/nilsblix";
            shell = pkgs.zsh;
        };
    };

    flake.modules.homeManager.nilsblix = { pkgs, ... }: {
        home.username = config.username;
        home.homeDirectory =
            if pkgs.stdenv.isDarwin then "/Users/nilsblix" else "/home/nilsblix";
        home.stateVersion = "25.05";
        programs.home-manager.enable = true;
    };
}
