{ config, ... }:
let
    inherit (config.flake.modules) darwin;
in {
    configurations.darwin.macos = {
        system = "aarch64-darwin";
        module.imports = [
            darwin.host-macbook-pro-m1
            darwin.nix
            darwin.nilsblix
            darwin.fonts
            darwin.packages
            darwin.shell
            darwin.desktop
            darwin.homebrew
            darwin.home-manager
        ];
    };

    flake.modules.darwin.host-macbook-pro-m1 = {
        ids.gids.nixbld = 350;
        nixpkgs.hostPlatform = "aarch64-darwin";
        system.stateVersion = 5;

        networking = {
            computerName = "Nilss Macbook Pro 14";
            hostName = "runner";
            localHostName = "nilsblix-mbp2021";
        };
    };
}
