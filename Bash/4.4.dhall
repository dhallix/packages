    let nix-dhall = ./../dhall/nix-dhall.dhall

in    λ ( write-text
        :   { name : Text, source : Text }
          → ./../dhall/Derivation.dhall
        )
    → λ(busybox : ./../dhall/Derivation.dhall)
    →     let src =
                nix-dhall.fetchurl
                { name =
                    "bash-4.4.tar.gz"
                , url =
                    "http://ftp.gnu.org/gnu/bash/bash-4.4.tar.gz"
                , sha256 =
                    "1jyz6snd63xjn6skk7za6psgidsd53k05cr3lksqybi0q6936syq"
                , executable =
                    False
                }
      
      in  let build-script =
                write-text
                { name =
                    "bash-builder"
                , source =
                    ''
                    export PATH=$gcc/bin:$bootstrap/bin:$PATH
                    $bootstrap/bin/tar xzf $source
                    cd bash-4.4
                    ./configure --prefix=$out
                    make
                    make install
                    ''
                }
      
      in  nix-dhall.derivation
          (   nix-dhall.defaults.DerivationArgs
            ⫽ { builder =
                  nix-dhall.Builders.Derivation
                  { derivation = busybox, bin = λ(out : Text) → out }
              , system =
                  nix-dhall.Systems.x86_64-linux {=}
              , name =
                  "bash-4.4"
              , environment =
                  [ { name =
                        "source"
                    , value =
                        nix-dhall.EnvironmentVariables.Derivation src
                    }
                  , { name =
                        "busybox"
                    , value =
                        nix-dhall.EnvironmentVariables.Derivation busybox
                    }
                  , { name =
                        "bootstrap"
                    , value =
                        nix-dhall.EnvironmentVariables.Derivation
                        (./../bootstrapping/bootstrap-tools.dhall busybox)
                    }
                  , { name =
                        "gcc"
                    , value =
                        nix-dhall.EnvironmentVariables.BootstrapGCC {=}
                    }
                  ]
              , args =
                  [ nix-dhall.DerivationArguments.`Text` "ash"
                  , nix-dhall.DerivationArguments.Derivation build-script
                  ]
              }
          )
