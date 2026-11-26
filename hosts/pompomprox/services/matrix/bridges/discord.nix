{ ... }:

{
  services.mautrix-discord = {
    enable = true;

    environmentFile = "/etc/secret/matrix-bridges/discord.env";

    settings = {
      homeserver = {
        address = "http://127.0.0.1:6167";
        domain = "iwannafuckmy.computer";
        software = "standard";
      };

      appservice = {
        address = "http://127.0.0.1:29334";
        hostname = "127.0.0.1";
        port = 29334;
      };

      bridge = {
        encryption = {
          allow = true;
          default = true;
          require = false;
          pickle_key = "$MAUTRIX_DISCORD_PICKLE_KEY";
        };

        permissions = {
          "iwannafuckmy.computer" = "user";
          "@jirachi:iwannafuckmy.computer" = "admin";
        };
      };
    };
  };
}
