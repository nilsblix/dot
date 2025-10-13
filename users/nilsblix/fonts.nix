{ inputs, pkgs, ... }:
{
    fonts = {
        packages = with pkgs; [
            nerd-fonts.hack
            nerd-fonts.jetbrains-mono
            nerd-fonts.fira-code
            nerd-fonts.iosevka
            inputs.sf-mono-nf.packages.${pkgs.system}.default
            inputs.monaco-nf.packages.${pkgs.system}.monaco
        ];
    };
}
