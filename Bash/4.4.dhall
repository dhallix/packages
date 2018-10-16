    let nix-dhall = ./../dhall/nix-dhall.dhall 

in  let Derivation = ../dhall/Derivation.dhall 

in    λ ( args
        : { download :
              { name : Text, url : Text, sha256 : Text } → Derivation
          , unpack :
              Derivation → Derivation
          , subpath :
              { original : Derivation, subpath : Text } → Derivation
          }
        )
    →     let top-dir = "bash-4.4"
      
      in  args.subpath
          { original =
              args.unpack
              ( args.download
                (     let file = "${top-dir}.tar.gz"
                  
                  in  { name =
                          file
                      , url =
                          "http://ftp.gnu.org/gnu/bash/${file}"
                      , sha256 =
                          "1jyz6snd63xjn6skk7za6psgidsd53k05cr3lksqybi0q6936syq"
                      }
                )
              )
          , subpath =
              "${top-dir}/*"
          }
