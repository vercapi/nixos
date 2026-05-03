# nixos

Flake-based NixOS-WSL configuration.

## Usage

- Evaluate the flake: `nix --extra-experimental-features 'nix-command flakes' flake show path:$PWD`
- Build the system without switching: `nix --extra-experimental-features 'nix-command flakes' build --no-link path:$PWD#nixosConfigurations.nixos.config.system.build.toplevel`
- Test-activate it: `sudo nixos-rebuild test --flake .#nixos`
- Apply it: `sudo nixos-rebuild switch --flake .#nixos`

## Layout

- `flake.nix` pins inputs and defines `nixosConfigurations.nixos`
- `hosts/nixos/default.nix` is the host entrypoint
- `modules/` contains the split configuration modules for WSL settings, packages, fonts, shell defaults, and system versioning
