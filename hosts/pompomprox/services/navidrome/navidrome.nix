{
  config,
  lib,
  pkgs,
  ...
}:

{
  services.navidrome = {
    enable = true;
    package = pkgs.navidrome;

    user = "navidrome";
    group = "navidrome";
    openFirewall = false;

    # Secrets (Last.fm / Spotify keys, PasswordEncryptionKey) aus Datei, nicht in den Nix-Store
    # Inhalt z.B.: ND_PASSWORDENCRYPTIONKEY=...  /  ND_LASTFM_APIKEY=...  /  ND_LASTFM_SECRET=...
    environmentFile = "/etc/secret/navidrome/navidrome.env";

    settings = {
      Address = "127.0.0.1"; # nur hinter Reverse-Proxy
      Port = 4533;
      EnforceNonRootUser = true;

      MusicFolder = "/srv/music";

      EnableInsightsCollector = false;

      # Für tinyauth
      "ExtAuth.TrustedSources" = "127.0.0.1";
      "ExtAuth.UserHeader" = "Remote-User";

      # Plugins = {
      #   Enabled = true;
      #   Folder = "/var/lib/navidrome/plugins";
      # };
    };
  };

  # Gruppe für Lesezugriff auf die Musik:
  # navidrome darf nur lesen (Gruppenmitglied), du darfst Musik hinzufügen
  users.groups.music = { };
  users.users.navidrome.extraGroups = [ "music" ];
  users.users.helly.extraGroups = [ "music" ];

  # setgid + rwx Besitzer, r-x Gruppe, nichts für andere
  systemd.tmpfiles.rules = [
    "d /srv/music 2750 helly music -"
  ];

  # Reverse proxy: Subsonic-API ohne Auth-Prompt, Rest hinter tinyauth
  services.caddy.virtualHosts."iwannafuckmycomputer.pompomsoft.de".extraConfig = ''
    handle /rest/* {
      reverse_proxy 127.0.0.1:4533
    }

    handle /share/* {
      reverse_proxy 127.0.0.1:4533
    }

    handle {
      forward_auth 127.0.0.1:3030 {
        uri /api/auth/caddy
        copy_headers Remote-User Remote-Email Remote-Name
      }
      reverse_proxy 127.0.0.1:4533
    }
  '';
}
