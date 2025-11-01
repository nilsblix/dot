{ inputs, pkgs, ... }:
{
    fonts = {
        packages = with pkgs; [
            nerd-fonts.jetbrains-mono
            nerd-fonts.iosevka
            nerd-fonts.lilex
            ibm-plex
            inputs.monaco-nf.packages.${pkgs.system}.monaco
        ];
    };
}
