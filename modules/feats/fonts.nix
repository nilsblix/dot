{ inputs, ... }:
let
    fonts = { pkgs, ... }: {
        fonts.packages = with pkgs; [
            courier-prime
            nerd-fonts.jetbrains-mono
            plemoljp-nf
            inputs.nilsblix-sf-mono-nf.packages.${pkgs.stdenv.hostPlatform.system}.default
        ];
    };
in {
    flake.modules.darwin.fonts = fonts;
    flake.modules.nixos.fonts = fonts;
}
