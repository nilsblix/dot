{ ... }:
{
    flake.modules.darwin.desktop = {
        power.sleep = {
            computer = 50;
            display = 30;
        };

        security.pam.services.sudo_local = {
            reattach = true;
            touchIdAuth = true;
        };

        system = {
            keyboard = {
                enableKeyMapping = true;
                remapCapsLockToEscape = true;
            };
            defaults = {
                NSGlobalDomain = {
                    AppleShowAllFiles = true;
                    InitialKeyRepeat = 18;
                    KeyRepeat = 1;
                    NSWindowShouldDragOnGesture = true;
                };
                controlcenter = {
                    Bluetooth = true;
                    FocusModes = false;
                    NowPlaying = false;
                    Sound = true;
                };
                dock = {
                    autohide = true;
                    orientation = "bottom";
                    persistent-apps = [];
                    show-recents = false;
                    wvous-bl-corner = 10;
                    wvous-br-corner = 1;
                    wvous-tl-corner = 5;
                    wvous-tr-corner = 1;
                };
                finder = {
                    AppleShowAllExtensions = true;
                    AppleShowAllFiles = true;
                    FXPreferredViewStyle = "Nlsv";
                    NewWindowTarget = "Home";
                    ShowStatusBar = true;
                    _FXShowPosixPathInTitle = true;
                };
                screensaver = {
                    askForPassword = true;
                    askForPasswordDelay = 0;
                };
            };
        };
    };

    flake.modules.nixos.desktop = {
        console.keyMap = "sv-latin1";
        time.timeZone = "Europe/Stockholm";

        services.desktopManager.plasma6.enable = true;
        services.displayManager.sddm.enable = true;
        services.xserver = {
            enable = true;
            videoDrivers = [
                "nvidia"
            ];
            xkb.layout = "se";
            xkb.options = "caps:escape,lv3:lalt_switch";
            xkb.variant = "mac";
        };
    };
}
