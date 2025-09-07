# A triple-function. (system, user, darwin) -> (name) -> (nixpkgs, inputs)
{ overlays, nixpkgs, inputs, ... }:
name:
{
    system,
    user,
    # If setupHomebrew is false it will still download casks and brews.
    # setupHomebrew only installs homebrew with nix-homebrew and setups
    # declarative taps. All homebrew config is done via `homebrew.*` in
    # home-manager.nix.
    darwin ? { enable = false; },
}:

let
    isDarwin = darwin.enable != false;

    machineConfig = ../machines/${name}.nix;
    userOSConfig = ../users/${user}/${if isDarwin then "darwin" else "nixos"}.nix;
    userHMConfig = ../users/${user}/home-manager.nix;

    systemFunc = if isDarwin then inputs.nix-darwin.lib.darwinSystem else nixpkgs.lib.nixosSystem;
    home-manager = if isDarwin then inputs.home-manager.darwinModules else inputs.home-manager.nixosModules;
in systemFunc rec {
    inherit system;

    specialArgs = {
        inherit inputs system user name;
    };

    modules = [
        {
            nixpkgs.config.allowUnfree = true;
            nixpkgs.overlays = overlays;
            nix.nixPath = [ "nixpkgs=${nixpkgs}" ];
        }

        machineConfig
        userOSConfig
        home-manager.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${user} = import userHMConfig { inherit inputs; };
        }
    ] ++ (if isDarwin && (darwin.declarativeHomebrew or false) then [
        inputs.nix-homebrew.darwinModules.nix-homebrew {
            nix-homebrew = {
                enable = true;
                enableRosetta = true;
                user = user;
                taps = {
                    "homebrew/homebrew-core" = inputs.homebrew-core;
                    "homebrew/homebrew-cask" = inputs.homebrew-cask;
                };
            };
        }
    ] else []);
}
