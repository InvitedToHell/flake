{
  config,
  pkgs,
  ...
}:

{
  virtualisation = {
    docker.enable = true;

    oci-containers = {
      backend = "docker";
      containers.minecraft = {
        image = "itzg/minecraft-server:latest";
        ports = [ "25565:25565" ];
        environment = {
          EULA = "TRUE";
          TYPE = "FABRIC";
          VERSION = "26.3"; # Minecraft version; picks the latest NeoForge for it
          MEMORY = "9G"; # adjust to your server's RAM
          OPS = "InvitedToHeaven"; # optional: auto-op yourself
          TZ = "Europe/Berlin";
        };
        volumes = [
          "/var/lib/minecraft/data:/data"
          "/var/lib/minecraft/mods:/mods:ro" # drop mod jars here
        ];
      };
    };
  };

  # The container runs as UID/GID 1000 by default
  systemd.tmpfiles.rules = [
    "d /var/lib/minecraft/data 0755 1000 1000 -"
    "d /var/lib/minecraft/mods 0755 1000 1000 -"
  ];

  networking.firewall.allowedTCPPorts = [ 25565 ];
}
