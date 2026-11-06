{
  config,
  pkgs,
  ...
}:

{
  services.tinyauth = {
    enable = true;
    environmentFile = "/etc/secret/tiny-auth/secret.env";

    settings = {
      APPURL = "https://auth.${config.domain}";
      SERVER_PORT = 3030;
      AUTH_TRUSTEDPROXIES = "127.0.0.1";
    };
  };

  # Reverse proxy
  services.caddy.virtualHosts."auth.${config.domain}".extraConfig = ''
    reverse_proxy http://127.0.0.1:3030
  '';
}
