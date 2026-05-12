{ config, inputs, lib, ... }:
{
    options.configurations = {
        darwin = lib.mkOption {
            type = lib.types.lazyAttrsOf (lib.types.submodule {
                options = {
                    system = lib.mkOption {
                        type = lib.types.singleLineStr;
                    };
                    module = lib.mkOption {
                        type = lib.types.deferredModule;
                    };
                };
            });
            default = {};
        };

        nixos = lib.mkOption {
            type = lib.types.lazyAttrsOf (lib.types.submodule {
                options.module = lib.mkOption {
                    type = lib.types.deferredModule;
                };
            });
            default = {};
        };
    };

    config.flake = {
        darwinConfigurations = lib.mapAttrs (_: { system, module }:
            inputs.nix-darwin.lib.darwinSystem {
                inherit system;
                modules = [
                    module
                ];
            }
        ) config.configurations.darwin;

        nixosConfigurations = lib.mapAttrs (_: { module }:
            inputs.nixpkgs.lib.nixosSystem {
                modules = [
                    module
                ];
            }
        ) config.configurations.nixos;
    };
}
