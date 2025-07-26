{
    description = "Skyfrei flake";
    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
        hypr = {
            url = "github:Skyfrei/hyprland";
            flake = false;

        };

        tmux = {
            url = "github:Skyfrei/tmux";
            flake = false;

        };
	      home-manager = {
		        url = "github:nix-community/home-manager";
		        inputs.nixpkgs.follows = "nixpkgs";
	      };
    };

    outputs = { self, nixpkgs, ... } @inputs: {
        nixosConfigurations.nixos = nixpkgs.lib.nixosSystem{
            system = "x86_64-linux"; 
	          specialArgs = { inherit inputs; };
	          modules = [
		            ./configuration.nix
	              inputs.home-manager.nixosModules.home-manager
	          ];
        };
    };
}
