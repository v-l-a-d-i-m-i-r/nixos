# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  release = "21.11";
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-${release}.tar.gz";

in
{
  imports = [
    ./hardware-configuration.nix
    (import "${home-manager}/nixos")
  ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  boot = {
   # kernelParams = [ "acpi_rev_override" ];
    kernelModules = [ "acpi_call" ];
    extraModulePackages = with config.boot.kernelPackages; [ acpi_call ];
  };

  hardware.cpu.intel.updateMicrocode = true;
  #hardware.enableAllFirmware = true;

  networking.hostName = "nas";
  networking.useDHCP = false;
  networking.interfaces.enp2s0.useDHCP = true;
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.interfaces.wlp0s29f7u1.useDHCP = true;

  time.timeZone = "Europe/Kiev";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    git
    zsh
    rxvt_unicode.terminfo
    htop
    glances
    pciutils
    powertop
  ];
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.passwordAuthentication = true;
  services.openssh.permitRootLogin = "yes";

  virtualisation.docker.enable = true;

  users.users.vladimir = {
    createHome = true;
    isNormalUser = true;
    extraGroups = [ "wheel" "disk" "docker" ];
    group = "users";
    home = "/home/vladimir";
    uid = 1000;
    shell = pkgs.zsh;
  };

  home-manager.useGlobalPkgs = true;
  home-manager.users.vladimir = {config, ...}: {
    # https://discourse.nixos.org/t/adding-folders-and-scripts/5114/4
    # https://github.com/nix-community/home-manager/issues/589#issuecomment-466594137
    # ".zshrc".text = (builtins.readFile /etc/nixos/files/home/vladimir/.zshrc);
    home.file.".zshrc".source = /etc/nixos/files/home/vladimir/.zshrc;

    # home.activation.linkMyFiles = config.lib.dag.entryAfter ["writeBoundary"] ''
      #ln -s ${toString /etc/nixos/files/home/vladimir/.zshrc} ~/.zrc
   #'';
  };

  nix.autoOptimiseStore = true;
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "${release}"; # Did you read the comment?
}
