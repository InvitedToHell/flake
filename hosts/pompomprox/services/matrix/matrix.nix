{
  config,
  pkgs,
  lib,
  ...
}:

{
  # Matrix server (Continuwuity)
  services.matrix-continuwuity = {
    enable = true;
    package = pkgs.matrix-continuwuity_latest;

    settings.global = {
      server_name = "iwannafuckmy.computer";
      port = [ 6167 ];
      address = [
        "::1"
        "127.0.0.1"
      ];

      allow_public_room_directory_over_federation = true;
      allow_registration = false;
      allow_encryption = true;
      allow_federation = true;
      allow_check_password = false;
      new_user_displayname_suffix = " · ✨";
      ip_lookup_strategy = 4;
      force_migration = true;

      # PocketID (OIDC) authentication
      oauth.oidc = {
        enable = true;
        discovery_url = "https://id.pompomsoft.de";
        client_id = "continuwuity";
        client_secret_file = "/etc/secret/continuwuity/oidc_secret";

        # Allows new users to automatically register when logging in via PocketID
        allow_registration = true;

        # Map claims from PocketID
        user_id_claim = "sub";
        displayname_claim = "name";
      };

      trusted_servers = [ "matrix.org" ];
    };
  };

  # Reverse proxy
  services.caddy.virtualHosts = {
    "iwannafuckmy.computer".extraConfig = ''
      request_body {
        max_size 768MB
      }

      handle /.well-known/matrix/client {
        header Content-Type application/json
        header Access-Control-Allow-Origin *
        header Cache-Control "public, max-age=86400"
        respond `{"m.server":{"base_url":"https://iwannafuckmy.computer"},"org.matrix.msc4048.base_url":"https://iwannafuckmy.computer"}`
      }

      handle /.well-known/matrix/server {
        header Content-Type application/json
        respond `{"m.server":"iwannafuckmy.computer:443"}`
      }

      handle {
        reverse_proxy 127.0.0.1:6167 {
          header_up Host {host}
          header_up X-Real-IP {remote_host}
          header_up X-Forwarded-For {remote_host}
          header_up X-Forwarded-Proto {scheme}
        }
      }
    '';

    "s.iwannafuckmy.computer".extraConfig = ''
      reverse_proxy 127.0.0.1:6167
    '';

    "sable.iwannafuckmy.computer".extraConfig = ''
      root * ${pkgs.runCommand "sable-web" { } ''
        mkdir -p $out
        tar -xzf ${pkgs.fetchurl {
          url = "https://git.sable.moe/SableClient/sable-next/releases/download/v2.2.0/sable-2.2.0-web.tar.gz";
          sha256 = "sha256-V1G0tV5nsakTVyG3f2+dBSk3ABC9oYGdvnpqufN+5Q0=";
        }} -C $out --strip-components=1
      ''}
      file_server
      try_files {path} {path}/ /index.html
    '';
  };
}
