{ pkgs, copilot-cli, ... }:

{
  environment.systemPackages =
    with pkgs;
    [
      emacs
      git
      hunspell
      hunspellDicts.en_US
      hunspellDicts.nl_nl
      python3Full
      fish
      nodejs_24
      copilot-cli.packages.${pkgs.system}.default
    ];
}
