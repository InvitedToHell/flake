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
    nameservers = [
      "185.12.64.1"
      "185.12.64.2"
      "1.1.1.1"
      "8.8.8.8"
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
