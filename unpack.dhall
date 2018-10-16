    let Derivation = ../dhall/Nix/types/Derivation.dhall 

in  let EnvironmentVariable =
          constructors
          (../dhall/Nix/types/EnvironmentVariable.dhall  Derivation)

in    λ ( args
        : { run-script :
                { script :
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
              → Derivation
          , bootstrap :
              Derivation
          }
        )
    → λ(x : Derivation)
    → args.run-script
      { script =
          ''
          export PATH=$bootstrap/bin:$PATH
          mkdir -p $out
          $bootstrap/bin/tar xzf $source -C $out
          ''
      , output-name =
          "unpacked"
      , environment =
          [ { name =
                "bootstrap"
            , value =
                EnvironmentVariable.Derivation args.bootstrap
            }
          , { name = "source", value = EnvironmentVariable.Derivation x }
          ]
      }
