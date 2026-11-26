{ config, inputs, pkgs, ... }:

let
  pkgs-unstable = inputs.unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  services.mautrix-signal.package = pkgs-unstable.mautrix-signal.override { withGoolm = true; };

  services.mautrix-signal = {
    enable = true;
    environmentFile = "/etc/secret/matrix-bridges/signal.env";

    settings = {
      homeserver = {
        address = "http://127.0.0.1:6167";
        domain = "iwannafuckmy.computer";
        software = "standard";
      };

      appservice = {
        address = "http://127.0.0.1:29328";
        hostname = "127.0.0.1";
        port = 29328;
        bot.username = "signal";
      };

      encryption = {
        allow = true;
        default = true;
        msc4190 = true;
        self_sign = true;
        pickle_key = "$MAUTRIX_SIGNAL_PICKLE_KEY";
      };

      backfill = {
        enabled = true;
        max_initial_messages = 200;
      };

      bridge = {
        double_puppet = {
          server_map = {};
          allow_discovery = true;
        };

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

  systemd.services.mautrix-signal = {
    after = [ "matrix-continuwuity.service" ];
    wants = [ "matrix-continuwuity.service" ];
  };
}
