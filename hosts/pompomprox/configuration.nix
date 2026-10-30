{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    # Networking
    ./networking/networks.nix

    # Services
    ./services/services-enabled.nix
  ];

  # Boot
  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Locale
  time.timeZone = "Europe/Berlin";

  console = {
    font = "Lat2-Terminus16";
    keyMap = "de-latin1";
  };

  # User
  users.users.helly = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    initialPassword = "supermassivespassword";
    openssh.authorizedKeys = {
      keyFiles = [
        ./ssh/caddy
        ./ssh/netcup
      ];
      keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG+gTnIFuNXvOxcL/q1zeaVGKBgugByNW8X0Jtd02ho5 helly@hell"
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    vim
    neovim
    git
    wget
    htop
    btop
  ];

  services = {
    tailscale.enable = true;

    openssh = {
      enable = true;
      settings.PasswordAuthentication = false;
    };
  };

  virtualisation.podman.enable = true;

  system.stateVersion = "26.05";
}
