{
  inputs = {
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-20.09";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
  outputs = { self, nixpkgs-stable, nixpkgs-unstable, }:
    nixpkgs-stable // {
      legacyPackages = builtins.mapAttrs (system: pkgs:
        pkgs.appendOverlays [
          (final: prev: {
            unstable = nixpkgs-unstable.legacyPackages."${system}";
          })
        ]) nixpkgs-stable.legacyPackages;
    };
}
