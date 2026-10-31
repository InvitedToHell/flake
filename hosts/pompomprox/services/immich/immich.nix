{
  config,
  pkgs,
  inputs,
  ...
}:

let
  # Shared import of the unstable channel (with unfree allowed)
  unstable = import inputs.unstable {
    system = pkgs.system;
    config.allowUnfree = true;
  };
in
{
  # Use the immich module from unstable instead of the (older) stable one
  disabledModules = [ "services/web-apps/immich.nix" ];
  imports = [
    "${inputs.unstable}/nixos/modules/services/web-apps/immich.nix"
  ];

  services.immich = {
    enable = true;
    package = unstable.immich;
    host = "127.0.0.1";
    port = 2283;
    mediaLocation = "/var/lib/immich";

    database.enable = true;
    redis.enable = true;
    "machine-learning".enable = true;

    environment = {
      IMMICH_LOG_LEVEL = "warn";
    };
  };

  # Reverse proxy
  services.caddy.virtualHosts."immich.pompomsoft.de".extraConfig = ''
    reverse_proxy http://127.0.0.1:2283
  '';
}
