# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{ config, lib, pkgs, ... }:


let
  copilot-cli = pkgs.callPackage (pkgs.fetchFromGitHub {
    owner = "scarisey";
    repo = "copilot-cli-flake";
    rev = "main";
    sha256 = "sha256-s3b1IP5nI9/WYyxnTTX4Co8qla9NHhgfi4zL6UnehCA=";
    }) {};
in
{
  imports = [
    # include NixOS-WSL modules
    <nixos-wsl/modules>
  ];
 
  nixpkgs.config.allowUnfree = true;  
  wsl.enable = true;
  wsl.defaultUser = "nixos";

  environment.systemPackages = with pkgs; [
    emacs
    git
    hunspell
    hunspellDicts.en_US
    hunspellDicts.nl_nl
    python3Full
    fish
    nodejs_24
    copilot-cli
  ];
  
  fonts.packages = with pkgs; [
    proggyfonts
  ];

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}