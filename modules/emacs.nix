{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    emacs
    cmake
    gcc
    hunspell
    hunspellDicts.en_US
    hunspellDicts.nl_nl
    libtool
    libvterm
    gnumake
    pkg-config
    python3Full
  ];

  fonts.packages = with pkgs; [
    proggyfonts
  ];
}
