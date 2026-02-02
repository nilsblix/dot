{ inputs, pkgs, ... }:
{
    fonts = {
        packages = with pkgs; [
            courier-prime
            iosevka
            nerd-fonts.jetbrains-mono
            inputs.monaco-nf.packages.${pkgs.stdenv.hostPlatform.system}.monaco
        ];
    };
}
