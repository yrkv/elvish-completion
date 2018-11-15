use github.com/yrkv/elvish-completion/completion

use re

fn csl [arg list]{
  explode $list
  left = (re:replace ",[^,]*$" "" $arg)
  right = (re:replace ".*," "" $arg)

  if (has-value $list $right) {
    put $arg","
  }

  if (re:match "," $arg) {
    explode $list | peach [item]{
      if (not (re:match $item $arg)) {
        put $left","$item
      }
    }
  }
}

fn CONVS [arg]{
  csl $arg [
    scii    ebcdic  ibm       block
    unblock lcase   ucase     sparse
    swab    sync    excl      nocreat
    notrunc noerror fdatasync fsync
  ]
}

fn FLAG [arg]{
  csl $arg [
    append direct directory dsync 
    sync fullblock nonblock noatime
    nocache noctty nofollow count_bytes
    skip_bytes seek_bytes
  ]
}

tree = [
  &dd= [
    &"&&META&&"= (completion:combine-maps $completion:custom-meta[dd-style] [
      &
    ])
    &bs=          []
    &cbs=         []
    &conv=        $CONVS~
    &count=       []
    &ibs=         []
    &if=          $completion:relative-path
    &iflag=       $FLAG~
    &obs=         []
    &of=          $completion:relative-path
    &oflag=       $FLAG~
    &seek=        []
    &skip=        []
    &status=      [ none noxfer progress ]
  ]
]
