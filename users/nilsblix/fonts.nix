{ inputs, pkgs, ... }:
{
    fonts = {
        packages = with pkgs; [
            courier-prime
            nerd-fonts.jetbrains-mono
            inputs.sf-mono-nf.packages.${pkgs.stdenv.hostPlatform.system}.default
        ];
    };
}
