    let nix-dhall = ../dhall/package.dhall 

in  let Derivation = ../dhall/Nix/types/Derivation.dhall 

in    λ ( support
        : { write-file :
              { name : Text, source : Text } → Derivation
          , busybox :
              Derivation
          }
        )
    → λ ( args
        : { script :
              Text
          , output-name :
              Text
          , environment :
              List
              { name :
                  Text
              , value :
                  ../dhall/Nix/types/EnvironmentVariable.dhall  Derivation
              }
          }
        )
    → nix-dhall.derivation
      (   nix-dhall.defaults.DerivationArgs
        ⫽ { builder =
              nix-dhall.Builders.Derivation
              { derivation = support.busybox, bin = λ(out : Text) → out }
          , system =
              nix-dhall.Systems.x86_64-linux {=}
          , name =
              args.output-name
          , environment =
              args.environment
          , args =
              [ nix-dhall.DerivationArguments.`Text` "ash"
              , nix-dhall.DerivationArguments.Derivation
                ( support.write-file
                  { name =
                      "produce-${args.output-name}.sh"
                  , source =
                      args.script
                  }
                )
              ]
          }
      )
