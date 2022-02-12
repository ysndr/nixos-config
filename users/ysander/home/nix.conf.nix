secrets @ {gh_token ? false, ...}:
''
experimental-features = nix-command flakes
keep-outputs = true
keep-derivations = true

substituters = https://cache.nixos.org https://cache.nixos.org/ https://ysndr.cachix.org https://ocharles.cachix.org https://all-hies.cachix.org https://eigenvalue.cachix.org
trusted-public-keys = cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= ysndr.cachix.org-1:Yc/8iRx8QdQ7e2uZbeWJnX5S1vwyzhzj76bL/Z/Hl2g= ocharles.cachix.org-1:tZc7pKI8if0igUsr6QJD9GaM1pddllatd4W+8IQoH0I= all-hies.cachix.org-1:JjrzAOEUsD9ZMt8fdFbzo3jNAyEWlPAwdVuHw4RD43k= eigenvalue.cachix.org-1:ykerQDDa55PGxU25CETy9wF6uVDpadGGXYrFNJA3TUs=

access-tokens = ${if secrets ? gh_token then "github.com=${secrets.gh_token}" else ""}
''
