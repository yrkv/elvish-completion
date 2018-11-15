use re

descriptors = [
  next    prev 
  any     last 
  newest  older 
  newer   focused
]

modifiers = [
  occupied focused urgent local
]

fn verify [arg]{
  re:match "^(.+#)?[0-9a-zA-Z@:/]+(\\.!?[a-z_]+)*$" $arg
}

fn select [arg]{
  ref = ""
  if (re:match "#" $arg) {
    ref = (re:replace "#.*" "#" $arg)
  }
  arg = (re:replace ".*#" "" $arg)
  ids = [(bspc query -D)]
  nth-desktops = ["^"(range 1 (+ (count $ids) 1))]
  names = [(bspc query -D --names)]

  desc = [$@descriptors $@ids $@nth-desktops $@names]

  descriptor = (re:replace "\\..*" '' $arg)

  if (re:match "\\." $arg) {
    end = [(re:find "[.!]" $arg)][-1][end]
    substr = $ref""$arg[:$end]

    each [mod]{
      if (not (re:match $mod $substr)) {
        echo $substr""$mod
      }
    } $modifiers


    if (re:match "^\\." $substr) {
      echo $substr"!"
    }

    if (has-value $modifiers (re:replace ".*[.!]" '' $arg)) {
      echo $arg"."
      echo $arg".!"
    }

  } else {
    put $ref""$@desc
    if (has-value $descriptors $arg) {
      put $ref""$arg"."
      put $ref""$arg".!"
    }
  }
}

optional = [
  &"&&META&&"=[
    &optional=$true
    &verify=[arg current meta]{
      verify $arg
    }
  ]
  &"&&OPTIONS&&"= $select~
]
