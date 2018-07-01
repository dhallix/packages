    let busybox = ./busybox/1.23.2.dhall

in  let write-file =
            λ(args : { name : Text, source : Text })
          → ./utils/write-file.dhall (args ⫽ { busybox = busybox })

in  let bash = ./Bash/4.4.dhall write-file busybox

in  { busybox = busybox, bash = bash }
