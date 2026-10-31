{
  lib,
  config,
  ...
}:

let
  livekitDomain = "livekit.call.iwannafuckmy.computer";
  lkJwtServiceDomain = "lk-jwt.call.iwannafuckmy.computer";
in
{
  services.livekit = {
    enable = true;
    openFirewall = true;

    keyFile = "/etc/secret/livekit/keys";

    settings = {
      room.auto_create = false;
      rtc.use_external_ip = true;
    };
  };

  services.lk-jwt-service = {
    enable = true;
    livekitUrl = "wss://${livekitDomain}";
    keyFile = config.services.livekit.keyFile;
    port = 8080;
  };

  systemd.services.lk-jwt-service.environment.LIVEKIT_FULL_ACCESS_HOMESERVERS =
    "iwannafuckmy.computer";

  systemd.services = {
    livekit.serviceConfig.Restart = lib.mkForce "always";
    lk-jwt-service.serviceConfig.Restart = lib.mkForce "always";
  };

  services.caddy.virtualHosts = {
    "${livekitDomain}".extraConfig = ''
      reverse_proxy 127.0.0.1:7880
    '';

    "${lkJwtServiceDomain}".extraConfig = ''
      reverse_proxy 127.0.0.1:${toString config.services.lk-jwt-service.port}
    '';
  };
}
