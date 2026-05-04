{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    emacs
    hunspell
    hunspellDicts.en_US
    hunspellDicts.nl_nl
    python3Full
  ];

  fonts.packages = with pkgs; [
    proggyfonts
  ];
}
