# dotunstable

Smuggle another version of nixpkgs around as an overlay.

Many nix configuration mechanisms (especially: modules) have special
treatment for nixpkgs, making a single `pkgs` parameter broadly available.

But nixpkgs is not a singular thing!  Many Nix users use the stable
`release-YYMM channel/branch for most packages and use the unstable
channel/branch for a few packages when a newer version is needed.

Adding the entire unstable branch as an overlay neatly solves this problem.

Need a newer `foo` package?  Just say `unstable.foo` instead of `foo`.

This repo makes this trick work in all evaluation contexts: in flakes,
with channels, in modules, or via `~/.config/nixpkgs/overlays/`.

This repo can be used as a drop-in replacement for `nixpkgs` as a nix
channel or as a flake input.  Define the actual nixpkgs versions you
want to use as `nixpkgs-stable` and `nixpkgs-unstable`.
