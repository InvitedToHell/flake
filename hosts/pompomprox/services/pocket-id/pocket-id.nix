{ config, ... }:

{
  services.pocket-id = {
    enable = true;

    credentials = {
      ENCRYPTION_KEY = "/etc/secret/pocket-id/encryption-key";
    };

    settings = {
      # <https://pocket-id.org/docs/configuration/environment-variables>
      APP_URL = "https://auth.pompomsoft.de";
      TRUST_PROXY = true;
      HOST = "127.0.0.1";
      PORT = 9000;
    };
  };

  services.caddy.virtualHosts."auth.pompomsoft.de".extraConfig = ''
    reverse_proxy 127.0.0.1:9000
  '';
}
