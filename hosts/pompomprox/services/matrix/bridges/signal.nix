{ ... }:

{
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
      };

      encryption = {
        allow = true;
        default = true;
        require = false;
        pickle_key = "$MAUTRIX_SIGNAL_PICKLE_KEY";
      };

      bridge = {
        permissions = {
          "iwannafuckmy.computer" = "user";
          "@jirachi:iwannafuckmy.computer" = "admin";
        };
      };
    };
  };
}
