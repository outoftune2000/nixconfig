# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let 
  unstable = import <unstable> {};
in
{
  nixpkgs.config.allowUnfree = true;
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <unstable/nixos/modules/services/misc/homepage-dashboard.nix>
    ];
   disabledModules = ["services/misc/homepage-dashboard.nix" ];


  # Bootloader
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  #boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.loader.grub.device = "nodev";
  boot.loader.grub.useOSProber = true;


  networking.hostName = "Tune"; # Define your hostname.
 # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_IN";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver = {
    enable = true;
    #desktopManager.plasma6.enable = true;
    xkb.layout = "us";
  };

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.displayManager.defaultSession = "none+awesome";
  # Enable awesome
services.xserver.windowManager.awesome = {
  enable = true;
  luaModules = with pkgs.luaPackages; [
    luarocks
    luadbi-mysql
  ];
};

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
   services.xserver.libinput.enable = true;

  #Enable flatpak 
   services.flatpak.enable = true;

   programs.zsh.enable = true;
   programs.dconf.enable = true;
   xdg.portal.enable = true; 
   programs.nix-ld.enable = true; #To run unpatched dynamic libraries
   xdg.portal.extraPortals = with pkgs; [
    xdg-desktop-portal-wlr
    xdg-desktop-portal-gtk
   ];

services.dbus.enable = true;

  #docker configurations
   virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
   };
#  security.acme = {
#	acceptTerms = true;
#	defaults.email = "athul.nazhiyath@gmail.com";
#	certs."athul.nazhiyath@gmail.com" = {
#		dnsProvider = "";
#		credentialsFile = "";
#		dnsPropagationCheck = true;
#	};
#};

   services.homepage-dashboard = {
	enable = true;
	package = unstable.homepage-dashboard;
	listenPort = 8082;
	bookmarks = [];
   };



  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ship = {
    isNormalUser = true;
    description = "Athul";
    initialPassword = "password";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
	    neovim
	    brave
	    htop
      neofetch
      code-cursor
      vlc
    #  thunderbird
    ];
  };


  security.sudo.extraRules = [{
	users = ["ship"];
	commands = [{command = "ALL";
		options = ["NOPASSWD"];
	}];
  }];
  # Install firefox.
  programs.firefox.enable = true;





#{
#              nixpkgs.config.permittedInsecurePackages = [
#                "deskflow"
#              ];
#            }


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim 
    wget
    nodejs
    git
    unstable.go
    pkgs.nix-ld
    pkgs.flatpak
    pkgs.incus
    pkgs.appimage-run
    pkgs.docker
    #unstable.deskflow
    #DE
    awesome
    playerctl
    gobject-introspection
    picom
    pavucontrol
    pulseaudio-ctl
    rofi
    wezterm
    hilbish
    emoji-picker
    spicetify-cli
    #terminals
    alacritty
    foot

    #shells
    nushell
    zsh
    nh
    kdePackages.dolphin
    #CLI tools
    bat
    cava
    cmake
    eza
    htop
    killall
    libnotify
    nano
    ncdu
    starship
    tree
    wev

    #programming
    libclang
    libgcc
    gcc
    llvmPackages_latest.libclang.lib
    rustc
    cargo
    jdk17
    nil
    hoppscotch
    vscodium
    maven
    nodejs_18

    #Desktop apps
    bibata-cursors
    bitwarden
    postgresql
    discord
    easyeffects
    gparted
    heroic
    libsForQt5.kate
    obs-studio
    qbittorrent
    qpwgraph
    rustdesk
    signal-desktop
    spotify
    transmission_3
    tutanota-desktop
    vesktop
    wireshark
    xfce.thunar
    xfce.thunar-volman
    xfce.thunar-archive-plugin
    xfce.thunar-media-tags-plugin
    shotgun
    gscreenshot
    #gaming
    goverlay
    lutris
    mangohud
    steam
  ];
  programs.mtr.enable = true;


  
  #appimage-run configurations
   boot.binfmt.registrations.appimage = {
	wrapInterpreterInShell = false;
	interpreter = "${pkgs.appimage-run}/bin/appimage-run";
	recognitionType = "magic";
	offset = 0;
	mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
	magicOrExtension = ''\x7fELF....AI\x02'';

};  

fonts.packages = with pkgs; [
  noto-fonts
  noto-fonts-cjk-sans
  noto-fonts-emoji
  roboto-mono

  (nerdfonts.override {fonts = ["JetBrainsMono" "DroidSansMono"];})
];
programs.steam = {
  enable = true;
  remotePlay.openFirewall = true;
  dedicatedServer.openFirewall = true;
};
  
  
  # Incus configs (lxc/lxd)

  virtualisation.incus.enable = true;


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };


  # List services that you want to enable:

  # Enable the OpenSSH daemon.
   services.openssh.enable = true;
   services.smartd.enable = true;

networking.firewall = {
    enable = true;
    allowedTCPPorts = [];
    allowedUDPPorts = [];
    allowedUDPPortRanges = [
      #kdeconnect
      {
        from = 1714;
        to = 1764;
      }
    ];
    allowedTCPPortRanges = [
      #kdeconnect
      {
        from = 1714;
        to = 1764;
      }
    ];
  };

   networking.firewall.trustedInterfaces = [ "incusbr0" ];
   networking.nftables.enable = true;
   environment.shells = with pkgs; [zsh];

   security.polkit.enable = true;

 # Nix daemon config
  nix = {
    # Automate garbage collection
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    # Flakes settings
    package = pkgs.nixVersions.git;

    settings = {
      # Automate `nix store --optimise`
      auto-optimise-store = true;

      # Required by Cachix to be used as non-root user
      trusted-users = [ "root" "gvolpe" ];

      experimental-features = [ "nix-command" "flakes" ];
      warn-dirty = false;

      # Binary caches
      substituters = [
        "https://cache.nixos.org"
        "https://cache.garnix.io"
        "https://gvolpe-nixos.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
        "gvolpe-nixos.cachix.org-1:0MPlBIMwYmrNqoEaYTox15Ds2t1+3R+6Ycj0hZWMcL0="
      ];

      # Avoid unwanted garbage collection when using nix-direnv
      keep-outputs = true;
      keep-derivations = true;
    };
  };
  
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}  