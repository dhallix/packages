    let nix-dhall = ./../dhall/nix-dhall.dhall 

in  let Derivation = ../dhall/Derivation.dhall 

in    λ ( args
        : { auto-tools :
              { source : Derivation, name : Text } → Derivation
          , source :
              Derivation
          }
        )
    → args.auto-tools { source = args.source, name = "bash" }
