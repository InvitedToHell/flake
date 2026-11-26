{ config, inputs, pkgs, ... }:

let
  pkgs-unstable = inputs.unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  services.mautrix-discord.package = pkgs-unstable.mautrix-discord.override { withGoolm = true; };

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
        bot.username = "discord";
      };

      encryption = {
        allow = true;
        default = true;
        msc4190 = true;
        self_sign = true;
        pickle_key = "$MAUTRIX_DISCORD_PICKLE_KEY";
      };

      bridge = {
        cleanup_on_logout = {
          enabled = true;
          manual = {
            private = "delete";
            relayed = "delete";
            shared_no_users = "delete";
            shared_has_users = "nothing";
          };
        };

        permissions = {
          "*" = "relay";
          "iwannafuckmy.computer" = "user";
          "@jirachi:iwannafuckmy.computer" = "admin";
        };
      };
    };
  };

  systemd.services.mautrix-discord = {
    after = [ "matrix-continuwuity.service" ];
    wants = [ "matrix-continuwuity.service" ];
  };
}
