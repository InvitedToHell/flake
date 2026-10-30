{ config, pkgs, ... }:

{ 
  services.degoog = {
    enable = true;
    
    environment = {
      PORT = "4444";
      DEGOOG_PUBLIC_INSTANCE = false;
      DEGOOG_BIND_ADDRESS = "127.0.0.1";
      DEGOOG_BASE_URL = "https://search.pompomsoft.de";
      DEGOOG_DISTRUST_PROXY = false;
    };
  };
  
  services.caddy.virtualHosts = {
      "search.pompomsoft.de".extraConfig = ''
        forward_auth 127.0.0.1:3030 {
          uri /api/auth/caddy
          copy_headers Remote-User Remote-Email
        }
        reverse_proxy 127.0.0.1:4444
      '';
  };
}
