{ ... }:
{
    flake.modules.homeManager.files = { pkgs, ... }: {
        home.file = {
            ".config/ghostty/config".source = ../../res/ghostty;
        } // (if pkgs.stdenv.isDarwin then {
            ".config/karabiner/karabiner.json".source =
                ../../res/karabiner.json;
        } else {});
    };
}
