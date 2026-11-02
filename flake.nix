{
  description = "PompomServer:tm:";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    degoog.url = "github:degoog-org/degoog";
    nix-minecraft.url = "github:Infinidoge/nix-minecraft";

 };

  outputs =
    {
      self,
      nixpkgs,
      degoog,
      nix-minecraft,
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
	    nix-minecraft.nixosModules.minecraft-servers
	    {
            nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];
            }

          ];
        };
    in
    {
      nixosConfigurations = {
        pompomprox = mkSystem "pompomprox";
      };
    };
}
