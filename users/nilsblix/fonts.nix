{ inputs, pkgs, ... }:
{
    fonts = {
        packages = with pkgs; [
            hack-font
            nerd-fonts.jetbrains-mono
            nerd-fonts.lilex
            inputs.monaco-nf.packages.${pkgs.system}.monaco
        ];
    };
}
