{ ... }:

{
  services.fail2ban = {
    enable = true;
    maxretry = 3;
    bantime = "48h"; # Ban IPs for one day on the first ban
    bantime-increment = {
      enable = true; # Enable increment of bantime after each violation
      formula = "ban.Time * math.exp(float(ban.Count+1)*banFactor)/math.exp(1*banFactor)";
      maxtime = "168h"; # Do not ban for more than 1 week
      overalljails = true; # Calculate the bantime based on all the violations
    };

    # ignoreIP = [
    #   # Allow list for some subnets
    #   "10.0.0.0/8" "172.16.0.0/12" "192.168.0.0/16"
    #   "8.8.8.8" # allow a specific IP
    #   "wiki.nixos.org" # resolve the IP via DNS
    # ];
  };
}
