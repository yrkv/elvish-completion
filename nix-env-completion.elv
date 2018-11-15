use github.com/yrkv/elvish-completion/completion
use str
use util

tree = [
  &"&&META&&"=[
    &ordered=$true
  ]
  &nix-env= [
    [
      &"&&META&&"=[
        &optional=$true
        &alternatives=[
          &-v=--verbose
          &-vv=--verbose
          &-vvv=--verbose
          &-vvvv=--verbose

          &-Q=--no-build-output
          &-j=--max-jobs
          &-k=--keep-going
          &-K=--keep-failed

          &-f=--file
          &-p=--profile
        ]
      ]
      &"&&OPTIONS&&"=[
        &--help=    []
        &--version= []

        &--verbose=         $completion:no-arg
        &--quiet=           $completion:no-arg
        &--no-build-output= &completion:no-arg

        &--max-jobs=        $completion:integer
        &--cores=           $completion:integer
        &--max-silent-time= $completion:integer
        &--timeout=         $completion:integer
        
        &--keep-going=      &completion:no-arg
        &--keep-failed=     &completion:no-arg
        &--fallback=        &completion:no-arg
        &--readonly-mode=   &completion:no-arg

        &-I=    [arg]{ $edit:completion:arg-completer[""] $arg }
        &--option=[
          &allowed-uris=        $completion:any-arg &allowed-users=      $completion:any-arg
          &builders=            $completion:any-arg &build-users-group=  $completion:any-arg
          &extra-sandbox-paths= $completion:any-arg &extra-platforms=    $completion:any-arg
          &extra-substituters=  $completion:any-arg &hashed-mirrors=     $completion:any-arg
          &plugin-files=        $completion:any-arg &substituters=       $completion:any-arg
          &system=              $completion:any-arg &trusted-public-keys=$completion:any-arg
          &trusted-substituters=$completion:any-arg &trusted-users=      $completion:any-arg
          &allow-import-from-derivation=[true false] &allow-new-privileges=    [true false]
          &auto-optimise-store=         [true false] &builders-use-substitutes=[true false]
          &compress-build-log=          [true false] &fallback=                [true false]
          &fsync-metadata=              [true false] &keep-build-log=          [true false]
          &keep-derivations=            [true false] &keep-env-derivations=    [true false]
          &keep-outputs=                [true false] &require-sigs=            [true false]
          &restrict-eval=               [true false] &sandbox=                 [true false]
          &show-trace=                  [true false] &substitute=              [true false]
          &connect-timeout=           $completion:integer &cores=                     $completion:integer
          &http-connections=          $completion:integer &max-build-log-size=        $completion:integer
          &max-free=                  $completion:integer &max-jobs=                  $completion:integer
          &max-silent-time=           $completion:integer &min-free=                  $completion:integer
          &narinfo-cache-negative-ttl=$completion:integer &narinfo-cache-positive-ttl=$completion:integer
          &repeat=                    $completion:integer &sandbox-dev-shm-size=      $completion:integer
          &timeout=                   $completion:integer
          &netrc-file=   $completion:absolute-path &pre-build-hook=  $completion:absolute-path
          &sandbox-paths=$completion:absolute-path &secret-key-files=$completion:absolute-path
        ]

        &--arg=[
          &"&&META&&"=[ &ordered=$true ]
          &"&&OPTIONS&&"=[ $completion:any-arg $completion:any-arg ]
        ]

        &--argstr=[
          &"&&META&&"=[ &ordered=$true ]
          &"&&OPTIONS&&"=[ $completion:any-arg $completion:any-arg ]
        ]

        &--file=[arg]{ $edit:completion:arg-completer[""] $arg }
        &--profile=[arg]{ $edit:completion:arg-completer[""] $arg }
        &--system-filter=$completion:any-arg
        &--dry-run=$completion:no-arg
      ]
    ]

    [
      &"&&META&&"=[
        &alternatives=[
          &-i=--install
          &-u=--upgrade
          &-e=--uninstall
          &-q=--query
          &-S=--switch-profile
          &-G=--switch-genetation
        ]
        &display-suffix=[
          &--install=" (-i)"
          &--upgrade=" (-u)"
          &--uninstall=" (-e)"
          &--query=" (-q)"
          &--switch-profile=" (-S)"
          &--switch-generation=" (-G)"
        ]

        &get-key=       [arg meta]{
          key = $arg
          try { key = $arg[0:2] } except { nop }
          if (eq $key "--") {
            key = $arg
          }
          $completion:default-meta[get-key] $key $meta
        }
        
        &get-options=[arg current meta]{
          extra = $current["&&EXTRA&&"]
          key = $arg
          try { key = $arg[0:2] } except { nop }
          if (has-key $extra $key) {
            keys $extra[$key] | peach [option]{
              if (not (str:contains $arg $option)) {
                edit:complex-candidate $arg""$option &display-suffix=$extra[$key][$option]
              }
            }
          }
          $completion:default-meta[get-options] $arg $current $meta
        }
      ]
      &"&&EXTRA&&"=[
        &-i=[
          &b=" (--prebuilt-only)"
          &P=" (--preserve-installed)"
          &r=" (--remove-all)"
          &A=" (--attr)"
        ]
        &-u=[
          &b=" (--prebuilt-only)"
          &A=" (--attr)"
        ]
        &-q=[
          &a=" (--available)"
          &s=" (--status)"
          &P=" (--attr-path)"
          &c=" (--compare-versions)"
          &b=" (--prebuilt-only)"
          &A=" (--attr)"
        ]
      ]
      &--install=[]
      &--upgrade=[]
      &--uninstall=[]
      &--set=[]
      &--set-flag=[]
      &--query=[]
      &--switch-profile=[arg]{ $edit:completion:arg-completer[""] $arg }
      &--list-generations=[]
      &--delete-generations=[]
      &--switch-generation=[]
      &--rollback=[]
    ]
  ]
]
