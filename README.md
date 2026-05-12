# nixfiles

> Personal Nix-configuration for my main systems.

## Flake Outputs

- `.#macos` (aarch64-darwin) → `modules/hosts/macbook-pro-m1.nix`
- `.#nixos` (x86_64-linux) → `modules/hosts/b550e.nix`

## Layout

This repository follows the dendritic pattern: every Nix file below `modules/`
is a flake-parts module. Feature modules expose lower-level NixOS, nix-darwin,
and home-manager modules through `flake.modules.*`; host modules compose those
features into concrete `darwinConfigurations` and `nixosConfigurations`.

## Installation

Notes
- This flake depends on a private repo `nilsblix/dot-private`. Authenticate
  GitHub before building.
- Nix 2.18+ is recommended. Flakes are enabled in the configs.

### macOS (nix-darwin)

1. Install Nix:

    ```bash
    sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install)
    ```

2. Authenticate GitHub for the private dependency:

    ```bash
    nix-shell -p git gh
    gh auth status || gh auth login
    ```

3. Clone this repository:

    ```bash
    git clone https://github.com/nilsblix/dot.git
    cd dot
    ```

4. Activate the configuration (bootstrap nix-darwin):

    ```bash
    nix run nix-darwin --extra-experimental-features "nix-command flakes" -- switch --flake .#macos
    ```

5. (Apple Silicon) Optional: install Rosetta for some Homebrew packages:

    ```bash
    softwareupdate --install-rosetta
    ```

### NixOS / Linux

1. Authenticate GitHub for the private dependency:

    ```bash
    nix-shell -p git gh
    gh auth status || gh auth login
    ```

2. Clone this repository:

    ```bash
    git clone https://github.com/nilsblix/dot.git
    cd dot
    ```

3. Activate the configuration:

    ```bash
    sudo nixos-rebuild switch --extra-experimental-features "nix-command flakes" --flake .#nixos
    ```

## Notes

- Darwin config enables declarative Homebrew via `nix-homebrew`; Homebrew is
  set up automatically and casks are managed in `modules/feats/homebrew.nix`.
- Channels are pinned to the 25.11 releases in `flake.nix`.
