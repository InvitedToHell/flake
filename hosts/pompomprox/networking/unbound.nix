{ config, ... }:

let
  tailnet = "100.64.0.0/10";
in
{
  services.unbound = {
    enable = true;
    localControlSocketPath = "/run/unbound/unbound.ctl";

    settings = {
      server = {
        interface = [
          "127.0.0.1"
          "::1"
          "tailscale0"
        ];

        prefer-ip6 = false;

        num-threads = 2;
        rrset-cache-size = "512m";
        msg-cache-size = "256m";
        infra-cache-numhosts = 50000;
        outgoing-range = 8192;
        num-queries-per-thread = 4096;

        so-rcvbuf = "4m";
        so-sndbuf = "4m";
        so-reuseport = true;

        prefetch = true;
        prefetch-key = true;
        serve-expired = true;

        private-domain = config.domain;
        domain-insecure = config.domain;
        unblock-lan-zones = true;
        insecure-lan-zones = true;

        extended-statistics = true;
        access-control = [
          "127.0.0.0/8 allow"
          "::1/128 allow"
          "${tailnet} allow"
          "0.0.0.0/0 refuse"
          "::/0 refuse"
        ];
      };

      remote-control.control-enable = true;
    };
  };

  boot.kernel.sysctl = {
    "net.core.rmem_max" = 4194304;
    "net.core.wmem_max" = 4194304;
  };

  systemd.services.unbound.serviceConfig.LimitNOFILE = 65536;

  systemd.services.unbound = {
    after = [ "tailscaled.service" ];
    wants = [ "tailscaled.service" ];
  };

  networking.firewall.interfaces.tailscale0 = {
    allowedTCPPorts = [ 53 ];
    allowedUDPPorts = [ 53 ];
  };
}
