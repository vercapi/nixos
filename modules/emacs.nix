{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    emacs
  
    cmake
    gcc
    libtool
    gnumake
    pkg-config
  
    hunspell
    hunspellDicts.en_US
    hunspellDicts.nl_nl
  
    libvterm
  
    python3Full
  ];

  fonts.packages = with pkgs; [
    proggyfonts
  ];
}
