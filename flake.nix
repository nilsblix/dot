{
    description = "Public system configuration via nix";

    inputs = {
        flake-parts.url = "github:hercules-ci/flake-parts";
        flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";
        import-tree.url = "github:vic/import-tree";

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

        nilsblix-glowstick.url = "github:nilsblix/glowstick";
        nilsblix-sf-mono-nf.url = "github:nilsblix/sf-mono-nf";
    };

    outputs = inputs:
        inputs.flake-parts.lib.mkFlake { inherit inputs; }
            (inputs.import-tree ./modules);
}
