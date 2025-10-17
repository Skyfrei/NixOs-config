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
    clang-tools
    clang
    rustc
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
    lldb
    nixfmt
    nixd
    perf
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
    cloc
    nodejs
    wireguard-tools
    weechat
    ];
  };
  programs.gnupg.agent = {
    enable = true;
  };
    
  networking.wg-quick.interfaces = {
    wg0 = {
      address = [ "10.80.4.254/15"];
      dns = [ "10.81.0.2" "10.81.0.3" "10.81.0.25" "1.1.1.1" "8.8.8.8"];
      privateKey = "eLrOtLvoDthx6YYEK9C2zzhWvrKzQBMcxKWKUS43QmI=";
      mtu = 1280;
      
      peers = [
        {
          publicKey = "gwcw/BGNjOKch5LzsztHcNqpmW/NIxmDeIIfs7ElGRQ=";
          presharedKey = "igWe6vOTJzeapmW7OGs88JBTcwTPpS4hzZVrHM1HBzk=";
          allowedIPs = ["10.80.0.0/15" ];
          endpoint = "128.131.169.157:51980";
          persistentKeepalive = 25;
        }
      ];
    };
  };

  networking.firewall = {
    allowedTCPPorts = [ 53 31337 ];
    allowedUDPPorts = [ 53 51820 51980];
  };

  virtualisation.docker = {
    enable = true;
    daemon.settings = {
        dns = [ "1.1.1.1" "8.8.8.8" ];
        log-driver = "journald";
        registry-mirrors = [ "https://mirror.gcr.io" ];
        storage-driver = "overlay2";
    };
    rootless = {
        enable = true;
        setSocketVariable = true;
    };
  };

  boot = {
    extraModulePackages = [ config.boot.kernelPackages.evdi config.boot.kernelPackages.perf ];
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


  services.udev.extraRules = ''
    # Kindle MTP device access
    SUBSYSTEM=="usb", ATTR{idVendor}=="1949", MODE="0666", GROUP="plugdev"
  '';

  system.stateVersion = "25.05"; # Did you read the comment?
}
