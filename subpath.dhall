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
    → λ(x : { original : Derivation, subpath : Text })
    → args.run-script
      { script =
          ''
          export PATH=$bootstrap/bin:$PATH
          mkdir -p $out
          cd $original
          cp -R $subpath $out/
          ''
      , output-name =
          "subpath"
      , environment =
          [ { name =
                "original"
            , value =
                EnvironmentVariable.Derivation x.original
            }
          , { name = "subpath", value = EnvironmentVariable.`Text` x.subpath }
          , { name =
                "bootstrap"
            , value =
                EnvironmentVariable.Derivation args.bootstrap
            }
          ]
      }
