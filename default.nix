args@{ ... }:
let
  stable = import <nixpkgs-stable> args;
  unstable = import <nixpkgs-unstable> args;
in stable.appendOverlays [ (final: prev: { inherit unstable; }) ]
