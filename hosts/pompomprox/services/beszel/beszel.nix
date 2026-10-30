{ pkgs, config, inputs, ... }:

let
  unstable = import inputs.unstable {
    system = pkgs.stdenv.hostPlatform.system;
    config = {
      allowUnfree = true;
    };
  };
in
{
  environment.systemPackages = [
    unstable.beszel
  ];

  systemd.services.beszel-hub = {
    description = "Beszel Hub Server";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      ExecStart = "${unstable.beszel}/bin/beszel-hub serve";
      Restart = "always";
      User = "beszel";
      StateDirectory = "beszel";
      WorkingDirectory = "/var/lib/beszel";
      Environment = [
        "USER_CREATION=true"
        "DISABLE_PASSWORD_AUTH=true"
        "PORT=8090"
      ];
    };
  };

  users.users.beszel = {
    isSystemUser = true;
    group = "beszel";
    home = "/var/lib/beszel";
    createHome = true;
  };
  users.groups.beszel = {};

  services.beszel.agent = {
    enable = true;
    package = unstable.beszel;
    environmentFile = "/etc/secret/beszel/key";
  };

  services.caddy.virtualHosts = {
    "beszel.pompomsoft.de".extraConfig = ''
        reverse_proxy http://127.0.0.1:8090
    '';
  };

}
