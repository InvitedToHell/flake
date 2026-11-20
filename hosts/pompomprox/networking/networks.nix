{ ... }:

{
  # Caddy reverse proxy
  services.caddy.enable = true;

  networking = {
    hostName = "pompomprox";

    useDHCP = false;
    interfaces.ens18.ipv4.addresses = [
      {
        address = "136.243.51.141";
        prefixLength = 26;
      }
    ];
    defaultGateway = "136.243.51.129";
    # Use the local unbound resolver (see unbound.nix).
    nameservers = [
      "127.0.0.1"
      "::1"
    ];

    firewall = {
      enable = true;
      allowedTCPPortRanges = [
        {
          from = 1;
          to = 65535;
        }
      ];
      allowedUDPPorts = [
        41641
      ];
      allowedUDPPortRanges = [
        {
          from = 50000;
          to = 51000;
        }
      ];
    };
  };
}
