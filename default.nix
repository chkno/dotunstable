let
  # We declare some parameters explicitly because nix's --arg command line
  # flag requires this.  Getting the list of parameters & constructing this
  # function dynamically would require import-from-derivation, which is not
  # permitted in some evaluation contexts, so we can't do that.  Instead, we
  # duplicate nixpkgs' list of explicit parameters here, with a check in case
  # it drifts out of sync.
  unused = builtins.throw "These default values are not used";
  toplevel = args@{ localSystem ? unused, system ? unused, platform ? unused
    , crossSystem ? unused, config ? unused, overlays ? unused
    , crossOverlays ? unused, ... }:
    let

      stable = import <nixpkgs-stable> args;
      unstable = import <nixpkgs-unstable> args;
      combined = stable.appendOverlays [ (final: prev: { inherit unstable; }) ];

      local-parameters = builtins.attrNames (builtins.functionArgs toplevel);
      remote-parameters =
        builtins.attrNames (builtins.functionArgs (import <nixpkgs-stable>));
      missing-parameters =
        combined.lib.subtractLists local-parameters remote-parameters;
      # Don't warn about extra args to avoid spurious warnings as everyone
      # rolls past nixpkgs commit 2dde58903e0f2f490088c3b0cedadc9b479da085
      # which removed the platform parameter.
      # extra-parameters =
      #   combined.lib.subtractLists remote-parameters local-parameters;
    in combined.lib.traceIf (missing-parameters != [ ])
    ("Note: dotunstable doesn't know about these nixpkgs parameters, "
      + "so they might not work with --arg on the nix command line: "
      + combined.lib.concatStringsSep " " missing-parameters) combined;

in toplevel
