{ ... }:

{
  imports = [
    ./beszel/beszel.nix
    ./degoog/degoog.nix
    ./fail2ban/fail2ban.nix
    ./forgejo/forgejo.nix
    ./immich/immich.nix
    ./matrix/matrix.nix
    ./matrix/matrixrtc.nix
    ./navidrome/navidrome.nix
    ./pocket-id/pocket-id.nix
    ./tiny-auth/tiny-auth.nix
    # ./minecraft/minecraft.nix
  ];
}
