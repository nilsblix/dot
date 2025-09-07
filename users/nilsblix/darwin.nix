{ pkgs, ...}:

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
        taps = [
            "homebrew/core"
            "homebrew/cask"
        ];
        casks = [
            "raycast"
            "signal"
            "karabiner-elements"
            "surfshark"
            "google-chrome"
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
                persistent-apps = [
                    {
                        app = "/Users/nilsblix/Applications/Home Manager Apps/Alacritty.app";
                    }
                ];
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
        };
    };

    security.pam.services.sudo_local.touchIdAuth = true;

    power.sleep = {
        computer = 50;
        display = 30;
    };
}

