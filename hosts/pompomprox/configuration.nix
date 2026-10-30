{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./networking/networks.nix
      ./networking/caddy.nix
      ./services/services-enabled.nix
];

  # Use the GRUB 2 boot loader.  
  boot.loader.grub.enable = true;
  boot.loader.grub.device ="/dev/sda";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  time.timeZone = "Europe/Berlin";

   console = {
     font = "Lat2-Terminus16";
     keyMap = "de-latin1";
  #   useXkbConfig = true; # use xkb.options in tty.
   };

  users.users.helly = {
     isNormalUser = true;
     extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
     initialPassword = "supermassivespassword";
   };

   environment.systemPackages = with pkgs; [
     vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
     htop
     btop
     wget
     neovim
     git
];

  services.tailscale.enable = true;
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = false;
  virtualisation.podman.enable = true;

  system.stateVersion = "26.05"; # Did you read the comment?
  users.users."helly".openssh.authorizedKeys.keyFiles = [
    ./ssh/caddy
    ./ssh/netcup
  ];
  users.users."helly".openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG+gTnIFuNXvOxcL/q1zeaVGKBgugByNW8X0Jtd02ho5 helly@hell"
  ];
}
