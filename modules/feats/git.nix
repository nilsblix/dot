{ inputs, ... }:
{
    flake.modules.homeManager.git = { ... }:
    let
        secretsFile = "${inputs.dot-private}/secrets.nix";
        secrets = if builtins.pathExists secretsFile then import secretsFile else {};
    in {
        programs.git = {
            enable = true;
            includes = [
                {
                    condition = "gitdir:~/Code/kth/**";
                    contents = {
                        user = secrets.kth;
                        url."ssh://nblix@gits-15.sys.kth.se/".insteadOf =
                            "https://gits-15.sys.kth.se/";
                        url."ssh://nblix@gits-15.sys.kth.se/".pushInsteadOf =
                            "https://gits-15.sys.kth.se/";
                    };
                }
            ];
            settings = {
                credential.helper = "osxkeychain";
                github.user = "nilsblix";
                user = {
                    email = secrets.personal_email;
                    name = "nilsblix";
                };
            };
        };
    };
}
