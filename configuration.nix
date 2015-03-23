let pkgs = import <nixpkgs> {};
    repo = import /home/a2/Projects/nixpkgs {};
    dirt = import /home/a2/Projects/nixpkgs.dirty {};

    phng = pkgs.haskell-ng;
    rhng = repo.haskell-ng;

    pcghc = phng.compiler;
    pcpak = phng.packages;
    rcghc = rhng.compiler;
    rcpak = rhng.packages;

    ghc710c = rcghc.ghc7101; 
    ghc710p = rcpak.ghc7101;

    rghc784c = rcghc.ghc784;
    rghc784p = rcpak.ghc784;
    pghc784c = pcghc.ghc784;
    pghc784p = pcpak.ghc784;

    ghcjsc = rcghc.ghcjs;
    ghcjsp = rcpak.ghcjs;
in

{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/sda";
  };

  networking = { 
    hostName = "import";
    hostId = "96540107";
    wireless.enable = false;
    useDHCP = false;
    interfaceMonitor.enable = false;
    wicd.enable = true;
    extraHosts = ''12.227.104.109 localhost'';
  };

  # Select internationalisation properties.
  i18n = {
    consoleFont = "lat9w-16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  environment.systemPackages = with pkgs; with emacs24Packages; with aspellDicts;
  [
    wget
    nox
    stdenv
    binutils
    patchelf
    unzip
    zlib
    glib
    htop
    redshift
    git
    aspell
    gnumake
    mupdf
    pghc784p.cabal2nix
    psmisc
    jack2
    jack_capture
    mplayer
    xvidcap
    repo.nix-repl

    emacs
    haskellMode
    #structured-haskell-mode

    firefoxWrapper
    chromium
    irssi
    repo.pidgin
    
    dmenu
    rghc784c
    rghc784p.cabal-install
    rghc784p.Agda
#    repo.AgdaSheaves
    repo.urweb
    j
    repo.leiningen

    haskellngPackages.xmobar
    haskellngPackages.xmonad
    haskellngPackages.xmonad-contrib
    haskellngPackages.xmonad-extras

    #leksah

    cudatoolkit6
    #accelerate-cuda
    
    wireshark

#    repo.emacs24PackagesNg.agda2-mode

  ];

  nix = {
    binaryCaches = ["https://hydra.nixos.org" "http://hydra.nixos.org" "https://cache.nixos.org" "http://cache.nixos.org" ]; # "http://hydra.cryp.to/" "https://hydra.cryp.to/" "https://ryantrinkle.com:5443" ];
    trustedBinaryCaches = ["https://hydra.nixos.org" "http://hydra.nixos.org" "https://cache.nixos.org" "http://cache.nixos.org" ]; # "http://hydra.cryp.to/" "https://hydra.cryp.to/" "https://ryantrinkle.com:5443" ];
    buildCores = 8;
    maxJobs = 1;
  };
  
  time.timeZone = "US/Pacific";

  services = {
    printing.enable = true;
    xserver = {
      enable = true;
        layout = "us";
      displayManager.slim = {
        defaultUser = "a2";
      };
      windowManager = {
        default = "xmonad";
        xmonad = {
          enable = true;
          enableContribAndExtras = true;
        };
      };
      videoDrivers = [ "nvidia" ];
    };
    virtualboxHost.enable = true;
  };

  hardware.opengl.driSupport32Bit = true;

  users = { 
    extraUsers.a2 = {
      isNormalUser = true;
      extraGroups = ["wheel"];
      uid = 1001;
    };
    extraGroups = {
      wireshark.gid = 500;
      vboxusers.members = [ "a2" ];
    };
    defaultUserShell = "/var/run/current-system/sw/bin/zsh";
  };

  security = {
    setuidOwners = [
      { program = "dumpcap";
        owner = "root";
        group = "wireshark";
        setuid = true;
        setgid = false;
        permissions = "u+rx,g+x";
      }
    ];
    sudo.wheelNeedsPassword = false;
  };

  programs.zsh.enable = true;

  nixpkgs.config.allowUnfree = true;

}
