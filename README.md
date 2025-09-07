# nixos-config

Personal Nix flake configuration.

## Installation

### On macOS

1. Install Nix:

    ```bash
    sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install)
    ```

2. Authorize GitHub to access this (private) repo:

    ```bash
    nix-shell -p git gh
    gh auth status
    gh auth login
    ```

3. Clone this repository:

    ```bash
    git clone https://github.com/nilsblix/nixos-config.git
    cd nixos-config
    ```

4. Activate the configuration:

    ```bash
    nix run github:LnL7/nix-darwin --extra-experimental-features "nix-command flakes" -- switch --flake .#<flake_name>
    ```

    Replace `<flake_name>` with your hostname or desired flake output.

5. (Optional) Install Rosetta for Homebrew-dependent packages:

    ```bash
    softwareupdate --install-rosetta
    ```

---

### On NixOS / Linux

1. Authorize GitHub to access this (private) repo:

    ```bash
    nix-shell -p git gh
    gh auth status
    gh auth login
    ```

2. Clone this repository:

    ```bash
    git clone https://github.com/nilsblix/nixos-config.git
    cd nixos-config
    ```

3. Activate the configuration:

    ```bash
    sudo nixos-rebuild switch --extra-experimental-features "nix-command flakes" --flake .#<flake_name>
    ```

    Replace `<flake_name>` with your hostname or desired flake output.
