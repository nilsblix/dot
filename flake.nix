{
    description = "Public system configuration via nix";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
        nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

        nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-25.11";
        nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

        home-manager.url = "github:nix-community/home-manager/release-25.11";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";

        nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

        homebrew-core.url = "github:homebrew/homebrew-core";
        homebrew-core.flake = false;

        homebrew-cask.url = "github:homebrew/homebrew-cask";
        homebrew-cask.flake = false;

        dot-private.url = "git+https://github.com/nilsblix/dot-private";
        dot-private.flake = false;

        glowstick.url = "github:nilsblix/glowstick";
        sf-mono-nf.url = "github:nilsblix/sf-mono-nf";
        neovim-flake.url = "github:nilsblix/neovim-flake";
    };

    outputs = { nixpkgs, ... }@inputs: let
        overlays = [
            inputs.neovim-flake.overlays.default
        ];

        mkSystem = import ./lib/mksystem.nix {
            inherit overlays nixpkgs inputs;
        };
    in {
        darwinConfigurations."macos" = mkSystem "macbook-pro-m1" {
            system = "aarch64-darwin";
            user = "nilsblix";
            darwin = {
                enable = true;
                declarativeHomebrew = true;
            };
        };

        nixosConfigurations."nixos" = mkSystem "b550e" {
            system = "x86_64-linux";
            user = "nilsblix";
        };
    };
}
