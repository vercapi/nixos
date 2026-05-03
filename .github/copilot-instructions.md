# Copilot instructions for this repository

## Validation commands

- `nix-instantiate --parse ./configuration.nix` — fastest syntax check.
- `sudo nixos-rebuild dry-build -I nixos-config=$PWD/configuration.nix` — evaluate and build without activating the system.
- `sudo nixos-rebuild test -I nixos-config=$PWD/configuration.nix` — build and activate temporarily for end-to-end validation.
- `sudo nixos-rebuild switch -I nixos-config=$PWD/configuration.nix` — apply the configuration after review.
- There is no repo-local lint script or unit/integration test runner. There is also no single-test entry point; validation is whole-configuration, so use `nix-instantiate --parse` first for narrow edits and `nixos-rebuild dry-build` for the full check.

## High-level architecture

- This repo is centered on a single NixOS module: `configuration.nix`. `README.md` is currently just a placeholder.
- `configuration.nix` is a plain module function (`{ config, lib, pkgs, ... }:`) that returns one top-level attrset. There is no flake, overlay tree, or module split yet.
- The `imports = [ <nixos-wsl/modules> ];` line makes the configuration an extension of the upstream NixOS-WSL modules. WSL behavior is then set in the same file with `wsl.enable` and `wsl.defaultUser`.
- A `let` binding defines a custom `copilot-cli` package by fetching `scarisey/copilot-cli-flake` from GitHub and instantiating it with `pkgs.callPackage`. That derived package is then added to `environment.systemPackages`.
- System packages, fonts, shell defaults, and release/version state all live in the same module, so most changes are edits to different blocks of one file rather than coordination across multiple modules.

## Key conventions

- Keep changes declarative in `configuration.nix`; avoid introducing imperative setup steps unless the repo structure changes to support them.
- Add packages through `environment.systemPackages = with pkgs; [ ... ];`. When a package needs custom fetch/build logic, bind it in `let` and reference the bound name in that package list.
- Keep WSL-specific behavior near the `imports` and `wsl.*` settings instead of scattering it across unrelated sections.
- Preserve `system.stateVersion` unless the task is explicitly about a NixOS release migration.
- This config already sets `nixpkgs.config.allowUnfree = true`; prefer normal package references over ad hoc workarounds for unfree packages.
