{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.default
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Berlin";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  programs.hyprland.enable = true;
  #services.xserver.videoDrivers = [ "displaylink" "modesetting" ];
  environment.systemPackages = with pkgs; [
    gcc
    clang
    rustc
    #python3
    go
    cargo
    cmake
    git
    ninja
    gnumake
    lua
    luarocks
    python313
    nix-index
    stdenv.cc.cc.lib
    pciutils
    usbutils
    lshw
    #pkg-config
    #openssl
    docker
    lldb
    nixfmt
    nixd
  ];

  users.users.sky = {
    isNormalUser = true;
    description = "Skyfrei";
    extraGroups = [
      "networkmanager"
      "wheel"
      "dialout"
    ];
    packages = with pkgs; [
      hyprland
      neovim
      firefox
      foot
      tmux
      fzf
      ripgrep
      waybar
      hyprpaper
      rofi
      qalculate-qt
      grim
      slurp
      wl-clipboard
      cliphist
      kdePackages.dolphin
      dunst
      lazygit
      xorg.xrandr
      p7zip
      weechat
      pipewire
      wireplumber
      qpwgraph
      rust-analyzer
      calibre
      google-chrome
    prismlauncher
    texlive.combined.scheme-full
    swww
    kicad
    ];
  };

  #virtualisation.docker = {
  #  enable = true;
  #};

  boot = {
    extraModulePackages = [ config.boot.kernelPackages.evdi ];
    initrd = {
      kernelModules = [
        "evdi"
      ];
    };
  };
programs.steam = {
  enable = true;
  remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
  dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
};

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "sky" = import ./home.nix;

    };
  };

  services.udev.extraRules = ''
    # Kindle MTP device access
    SUBSYSTEM=="usb", ATTR{idVendor}=="1949", MODE="0666", GROUP="plugdev"
  '';

  system.stateVersion = "25.05"; # Did you read the comment?
}
