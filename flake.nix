{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager }@inputs:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    localPkgs = pkgs.callPackage ./pkgs { };
  in {

    packages.${system} = {
      hello = pkgs.hello;
      notetask = localPkgs.notetask;
      vcard-studio = localPkgs.vcard-studio;
      default = self.packages.${system}.notetask;
    };

    nixosConfigurations.main = nixpkgs.lib.nixosSystem {
      system = system;
      specialArgs = {
        inherit inputs;
      };
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.satori = ./home.nix;

            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
          } ];
    };

  };
}
