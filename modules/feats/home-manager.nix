{ config, inputs, ... }:
let
    homeManagerUser = {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.${config.username}.imports = [
            config.flake.modules.homeManager.nilsblix
            config.flake.modules.homeManager.files
            config.flake.modules.homeManager.git
            config.flake.modules.homeManager.packages
            config.flake.modules.homeManager.programs
            config.flake.modules.homeManager.shell
        ];
    };
in {
    flake.modules.darwin.home-manager = {
        imports = [
            inputs.home-manager.darwinModules.home-manager
            homeManagerUser
        ];
    };

    flake.modules.nixos.home-manager = {
        imports = [
            inputs.home-manager.nixosModules.home-manager
            homeManagerUser
        ];
    };
}
