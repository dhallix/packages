    let busybox = ./busybox/1.23.2.dhall 

in  let bootstrap-tools = ./bootstrapping/bootstrap-tools.dhall  busybox

in  let run-script =
          ./run-script.dhall 
          { busybox =
              busybox
          , write-file =
              ./utils/write-file.dhall  { busybox = busybox }
          }

in  ./Bash/build.dhall 
    { source =
        ./Bash/4.4.dhall 
        { download =
            ./download.dhall 
        , unpack =
            ./unpack.dhall 
            { bootstrap = bootstrap-tools, run-script = run-script }
        , subpath =
            ./subpath.dhall 
            { bootstrap = bootstrap-tools, run-script = run-script }
        }
    , auto-tools =
        ./auto-tools.dhall 
        { run-script = run-script, bootstrap = bootstrap-tools }
    }
