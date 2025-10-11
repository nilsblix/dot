{ inputs, pkgs, ... }:
{
    fonts = {
        packages = with pkgs; [
            nerd-fonts.hack
            nerd-fonts.jetbrains-mono
            nerd-fonts.fira-code
            inputs.sf-mono-nf.packages.${pkgs.system}.default
            inputs.monaco-nf.packages.${pkgs.system}.monaco
        ];
    };
}
