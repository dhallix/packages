
  λ(busybox : ./../dhall/Derivation.dhall)
→     let nix-dhall =
            ./../dhall/nix-dhall.dhall
  
  in  let bootstrap-tools =
            nix-dhall.fetchurl
            { name =
                "bootstrap-tools.tar.xz"
            , url =
                "http://tarballs.nixos.org/stdenv-linux/x86_64/4907fc9e8d0d82b28b3c56e3a478a2882f1d700f/bootstrap-tools.tar.xz"
            , sha256 =
                "0p71bij6bfhzyrs8676a8jmpjsfz392s2rg862sdnsk30jpacb43"
            , executable =
                False
            }
  
  in  let unpack-bootstrap-tools =
            nix-dhall.fetchurl
            { name =
                "unpack-bootstrap-tools.sh"
            , url =
                "https://raw.githubusercontent.com/NixOS/nixpkgs/master/pkgs/stdenv/linux/bootstrap-tools/scripts/unpack-bootstrap-tools.sh"
            , sha256 =
                "00cq5zqksf3ijhdagih0d9qh8b25k8fij8yjmfr14vfwff0abakv"
            , executable =
                False
            }
  
  in  nix-dhall.derivation
      (   nix-dhall.defaults.DerivationArgs
        ⫽ { args =
              [ nix-dhall.DerivationArguments.`Text` "ash"
              , nix-dhall.DerivationArguments.Derivation unpack-bootstrap-tools
              ]
          , builder =
              nix-dhall.Builders.Derivation
              { derivation = busybox, bin = λ(out : Text) → out }
          , name =
              "bootstrap-tools"
          , system =
              nix-dhall.Systems.x86_64-linux {=}
          , environment =
              [ { name =
                    "tarball"
                , value =
                    nix-dhall.EnvironmentVariables.Derivation bootstrap-tools
                }
              ]
          }
      )
