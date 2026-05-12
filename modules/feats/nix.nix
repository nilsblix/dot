{ config, inputs, ... }:
let
    common = {
        nixpkgs.config.allowUnfree = true;
        nixpkgs.overlays = [];
        nix.nixPath = [
            "nixpkgs=${inputs.nixpkgs}"
        ];

        nix.settings = {
            experimental-features = [
                "nix-command"
                "flakes"
            ];
            trusted-users = [
                config.username
            ];
            extra-substituters = [
                "https://nix-community.cachix.org"
                "https://cache.numtide.com"
            ];
            extra-trusted-public-keys = [
                "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
            ];
        };
    };
in {
    flake.modules.darwin.nix = common;
    flake.modules.nixos.nix = common;
}
