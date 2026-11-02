{
  config,
  pkgs,
  inputs,
  ...
}:

{
  services.minecraft-servers = {
    enable = true;
    eula = true;

    servers.fabric = 	{
      enable = true;
      package = pkgs.fabricServers.fabric-26_2.override {
        loaderVersion = "0.20.1";
        jre_headless = pkgs.jdk25; 
      };
      jvmOpts = [
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
