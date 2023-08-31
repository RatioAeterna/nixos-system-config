# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  networking.useDHCP = false;
  networking.nameservers = [ "8.8.8.8" "8.8.4.4"];


  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

  # Enable the X11 windowing system.

  # Configure keymap in X11
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "eurosign:e,caps:escape";
  services.xserver = {
      enable=true;
      displayManager.lightdm.enable=true;
      displayManager.defaultSession="xfce+herbstluftwm";
      #displayManager.defaultSession="xfce+xmonad";
      desktopManager = {
          xterm.enable=true;
          xfce = {
              enable = true;
              noDesktop = true;
              enableXfwm = false;
          };
          gnome.enable = true;
      };
      windowManager.herbstluftwm.enable = true;

      #windowManager.start = ''
      #       ${pkgs.picom}/bin/picom &
      #   '';

      #windowManager = {
      #    xmonad = {
      #        enable = true;
      #        enableContribAndExtras = true;
      #        extraPackages = haskellPackages: [
      #            haskellPackages.xmonad-contrib
      #            haskellPackages.xmonad-extras
      #            haskellPackages.xmonad
      #            haskellPackages.ghc
      #            haskellPackages.data-default
      #            haskellPackages.xmobar
      #        ];
      #    };
      #}; 
};
      

  nixpkgs.config.allowUnfree = true;
  
  # zsh config (TODO apparently this must be enabled at system level i.e., in this file? But perhaps not?)
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  environment.shells = with pkgs; [ zsh ];


  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jason = {
     isNormalUser = true;
     extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
     home = "/home/jason";
  };

  home-manager.users.jason = { pkgs, ... }: {
      home.packages = [ ];
      programs.bash.enable = true;
      home.stateVersion = "23.05";
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
   environment.systemPackages = with pkgs; [
     vim 
     wget
     dig
     git
     vscode # TODO move this OUT OF HERE and into home-manager home.nix.. tricky, since it's not free
     zoom-us # TODO SAME
   ];


nix.settings.experimental-features = [ "nix-command" "flakes" ];


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
  services.picom.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}

