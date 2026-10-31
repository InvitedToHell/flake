{
  description = "PompomServer:tm:";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    degoog.url = "github:degoog-org/degoog";
  };

  outputs =
    {
      self,
      nixpkgs,
      degoog,
      ...
    }@inputs:
    let
      mkSystem =
        hostname:
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            degoog.nixosModules.default
            ./hosts/pompomprox/configuration.nix
          ];
        };
    in
    {
      nixosConfigurations = {
        pompomprox = mkSystem "pompomprox";
      };
    };
}
