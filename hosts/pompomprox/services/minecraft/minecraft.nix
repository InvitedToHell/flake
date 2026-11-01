{
  config,
  pkgs,
  inputs,
  ...
}:

let
  fabricPackage = inputs.nix-minecraft.packages.x86_64-linux.minecraftServers.fabric-1_21_11;
in

{
  services.minecraft-servers = {
    enable = true;
    eula = true;

    servers.fabric = {
      enable = true;
      package = fabricPackage;

      jvmArgs = [
        "-Xms4G"
        "-Xmx9G"
        "-XX:+UseG1GC"
      ];

      serverProperties = {
        motd = "PompomServer:tm:";
        difficulty = "normal";
        online-mode = true;
        white-list = true;
      };

      symlinks."mods" = "/var/lib/minecraft/mods";
    };
  };

  networking.firewall.allowedTCPPorts = [ 25565 ];
}
