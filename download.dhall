    let nix-dhall = ../dhall/package.dhall 

in    λ(args : { url : Text, sha256 : Text, name : Text })
    → nix-dhall.fetchurl
      { name =
          args.name
      , url =
          args.url
      , sha256 =
          args.sha256
      , executable =
          False
      }
