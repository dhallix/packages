    let Derivation = ./../../dhall/Nix/types/Derivation.dhall 

in  let nix-dhall = ./../../dhall/package.dhall 

in    λ(support : { busybox : Derivation })
    → λ(args : { name : Text, source : Text })
    → nix-dhall.derivation
      (   nix-dhall.defaults.DerivationArgs
        ⫽ { builder =
              nix-dhall.Builders.Derivation
              { derivation = support.busybox, bin = λ(out : Text) → out }
          , system =
              nix-dhall.Systems.x86_64-linux {=}
          , name =
              args.name
          , environment =
              [ { name =
                    "source"
                , value =
                    nix-dhall.EnvironmentVariables.`Text` args.source
                }
              ]
          , args =
              [ nix-dhall.DerivationArguments.`Text` "ash"
              , nix-dhall.DerivationArguments.LocalPath
                "/home/ollie/work/dhallpkgs/packages/utils/write-text.sh"
              ]
          }
      )
