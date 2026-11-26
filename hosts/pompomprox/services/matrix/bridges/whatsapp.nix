{ ... }:

{
  services.mautrix-whatsapp = {
    enable = true;

    environmentFile = "/etc/secret/matrix-bridges/whatsapp.env";

    settings = {
      homeserver = {
        address = "http://127.0.0.1:6167";
        domain = "iwannafuckmy.computer";
        software = "standard";
      };

      appservice = {
        address = "http://127.0.0.1:29318";
        hostname = "127.0.0.1";
        port = 29318;
      };

      encryption = {
        allow = true;
        default = true;
        require = false;
        pickle_key = "$MAUTRIX_WHATSAPP_PICKLE_KEY";
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
