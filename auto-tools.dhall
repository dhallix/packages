    let nix-dhall = ./dhall/nix-dhall.dhall 

in  let Derivation = ./dhall/Derivation.dhall 

in    λ ( deps
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
    → λ(args : { source : Derivation, name : Text })
    → deps.run-script
      { script =
          ''
          export PATH=$gcc/bin:$bootstrap/bin:$PATH
          cp -R $source/* .
          chmod -R a+rwx .
          ./configure --prefix=$out
          make
          make install
          ''
      , output-name =
          args.name
      , environment =
          [ { name =
                "bootstrap"
            , value =
                nix-dhall.EnvironmentVariables.Derivation deps.bootstrap
            }
          , { name =
                "source"
            , value =
                nix-dhall.EnvironmentVariables.Derivation args.source
            }
          , { name =
                "gcc"
            , value =
                nix-dhall.EnvironmentVariables.BootstrapGCC {=}
            }
          ]
      }
