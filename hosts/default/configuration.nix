{ config, pkgs, inputs,... }:
{
  imports = [
    ./hardware-configuration.nix
  ];
  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];


  programs.hyprland.enable = true;
  programs.hyprland.package = inputs.hyprland.packages."${pkgs.system}".hyprland;
  
  
  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;  # includes extra codecs and features
  };
  services.pipewire.enable = false;


  # GPU and Hardware Acceleration Support
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      amdvlk
      rocmPackages.clr   
    ];
  };

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Detroit";

  # Input method
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-mozc
      fcitx5-gtk
    ];
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Define a user account
  users.users.novuchuu = {
    isNormalUser = true;
    description = "novuchuu";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # System packages
  environment.systemPackages = with pkgs; [
    neovim
    hyprland
    google-chrome
    obsidian
    kitty
    nsxiv
    mpv
    wofi
    waybar  
    gdrive3
    hyprpaper
    alsa-utils
    pavucontrol
    easyeffects
    helvum
    spotify
    wget
    git
    dtrx
    gh
    wl-clipboard

    # Languages/Runtimes
    gleam
    erlang
    bun
    nodejs
    rustc    
    python3        
  ];
  #Home manager
  #home-manager = {
  #extraSpecialArgs = { inherit inputs;};
  #users = {
  #    "novuchuu" = import ./home.nix;
  #    extraSpecialArgs = { inherit inputs; };
  #  }; 
  #};

  #Fonts
fonts.packages = with pkgs; [ ] 
  ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);


  system.stateVersion = "24.05";	
}	

