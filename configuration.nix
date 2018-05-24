{ config, pkgs, ... }:

let repo = import /home/ace/src/internet/nixpkgs {};
      ob = import /home/ace/src/internet/obelisk {};
in

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.initrd.luks.devices = [
    {
      name = "root";
      device = "/dev/sda3";
      preLVM = true;
    }
  ];

  boot.loader.grub.device = "/dev/sda";  
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.extraModprobeConfig = ''
    options snd_hda_intel enable=0,1
  '';

  boot.blacklistedKernelModules = [ "snd_pcsp" ];

  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;
  hardware.pulseaudio.systemWide = true;

  nix.binaryCaches = [ "https://cache.nixos.org/" "https://nixcache.reflex-frp.org" ];
  nix.binaryCachePublicKeys = [ "ryantrinkle.com-1:JJiAKaRv9mWgpVAz8dwewnZe0AzzEAzPkagE9SP5NWI=" ];

  nix.envVars = {
    NIX_GITHUB_PRIVATE_USERNAME = "sheganinans";
    NIX_GITHUB_PRIVATE_PASSWORD = "218ea2aa56ecebf0bafa659f14c23da21ee78870";
  };

  nixpkgs.config.pulseaudio = true;
  nixpkgs.config.allowUnfree = true;

  networking.hostName = "ace"; # Define your hostname.
  networking.networkmanager.enable = true;

  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "Lat2-Terminus16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    ob.command

    binutils
    cabal-install
    repo.discord
    emacs
    ffmpeg
    gcc
    geoclue
    ghc
    git
    glib
    gnumake
    htop
    hub
    hunspell
    repo.j
    libreoffice
    libopus
    libsodium
    #mozpkgs.latest.rustChannels.nightly.rust
    #mozpkgs.latest.rustChannels.nightly.rust-src
    #mozpkgs.latest.rustChannels.stable.rust
    #mozpkgs.latest.rustChannels.stable.rust-src
    repo.nix-repl
    repo.nox
    repo.openssl
    repo.openssl.dev
    patchelf
    pkgconfig
    repo.quaternion
    redshift
    repo.signal-desktop
    stack
    stdenv
    repo.sublime3
    thunderbird
    tdesktop
    repo.telegram-cli
    unoconv
    unzip
    vim
    repo.vivaldi
    wget
    wireshark
    repo.wire-desktop
    youtube-dl
    zlib
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.bash.enableCompletion = true;
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  services.nixosManual.showManual = true;

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "us";
    # services.xserver.xkbOptions = "eurosign:e";

    # Enable touchpad support.
    libinput.enable = true;

    # Enable the KDE Desktop Environment.
    displayManager.sddm.enable = true;
    desktopManager.plasma5.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.ace = {
    name = "ace";
    isNormalUser = true;
    group = "users";
    extraGroups = [
      "wheel" "disk" "audio" "video"
      "networkmanager" "systemd-journal"
    ];
    createHome = true;
    uid = 1000;
    home = "/home/ace";
    shell = "/run/current-system/sw/bin/bash";
  };

  system.autoUpgrade.enable = true;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.03"; # Did you read the comment?

}
