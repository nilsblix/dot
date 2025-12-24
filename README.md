# dot

Public Nix flake configuration for macOS (nix-darwin) and NixOS, including Home Manager and declarative Homebrew.

## Flake Outputs

- `.#macos` (aarch64-darwin) → `machines/macbook-pro-m1.nix` + `users/nilsblix/darwin.nix`
- `.#nixos` (x86_64-linux) → `machines/b550e.nix` + `users/nilsblix/nixos.nix`

## Installation

Notes
- This flake depends on a private repo `nilsblix/dot-private`. Authenticate GitHub before building.
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

- Darwin config enables declarative Homebrew via `nix-homebrew`; Homebrew is set up automatically and casks are managed in `users/nilsblix/darwin.nix`.
- Channels are pinned to the 25.11 releases in `flake.nix`.
