{ config, pkgs, ...}:

{
    imports = [
        ./fonts.nix
    ];

    users.knownUsers = [ "nilsblix" ];
    users.users.nilsblix.uid = 501;
    users.users.nilsblix = {
        home = "/Users/nilsblix";
        shell = pkgs.zsh;
    };

    homebrew = {
        enable = true;
        taps = builtins.attrNames config.nix-homebrew.taps;
        casks = [
            "raycast"
            "signal"
            "karabiner-elements"
            "surfshark"
            "google-chrome"
            "ghostty"
            "spotify"
            "mattermost"
            "microsoft-powerpoint"
        ];
        onActivation.cleanup = "zap";
    };

    system = {
        # Unknown weird option for when updating the flake to 25.05
        primaryUser = "nilsblix";
        keyboard = {
            enableKeyMapping = true;
            remapCapsLockToEscape = true;
        };
        defaults = {
            dock = {
                orientation = "bottom";
                autohide = true;
                show-recents = false;
                wvous-tl-corner = 5; # start screensaver
                wvous-bl-corner = 10; # put display to sleep
                wvous-tr-corner = 1; # off
                wvous-br-corner = 1; # off
                # FIX
                # persistent-apps = [
                #     {
                #         app = "/Applications/Ghostty.app";
                #     }
                # ];
            };

            controlcenter = {
                Sound = true;
                Bluetooth = true;
                NowPlaying = false;
                FocusModes = false;
            };

            NSGlobalDomain = {
                KeyRepeat = 1; # how long between each repeat
                InitialKeyRepeat = 18; # how long before repeating
                NSWindowShouldDragOnGesture = true;
                AppleShowAllFiles = true;
            };

            screensaver = {
                askForPassword = true;
                askForPasswordDelay = 0;
            };

            finder = {
                ShowPathbar = true;
            };
        };
    };

    power.sleep = {
        computer = 50;
        display = 30;
    };
}

