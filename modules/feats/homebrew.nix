{ config, inputs, ... }:
let
    username = config.username;
in {
    flake.modules.darwin.homebrew = { config, ... }: {
        imports = [
            inputs.nix-homebrew.darwinModules.nix-homebrew
        ];

        homebrew = {
            enable = true;
            casks = [
                "google-chrome"
                "karabiner-elements"
                "mattermost"
                "microsoft-powerpoint"
                "raycast"
                "signal"
                "spotify"
                "surfshark"
                "zed"
                "zoom"
            ];
            onActivation = {
                cleanup = "zap";
                extraFlags = [
                    "--verbose"
                ];
            };
            taps = builtins.attrNames config.nix-homebrew.taps;
        };

        nix-homebrew = {
            enable = true;
            enableRosetta = true;
            mutableTaps = false;
            user = username;
            taps = {
                "homebrew/homebrew-cask" = inputs.homebrew-cask;
                "homebrew/homebrew-core" = inputs.homebrew-core;
            };
        };
    };
}
