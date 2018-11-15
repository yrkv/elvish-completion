use re

use github.com/yrkv/elvish-completion/bspwm/selectors/desktop

descriptors = [
  north west south east
  next prev
  any
  last
  newest
  older newer
  focused
  pointed
  biggest
]

modifiers = [
  focused     automatic    local
  active      leaf         window
  tiled       pseudo_tiled floating
  fullscreen  same_class   descendant_of
  ancestor_of hidden       sticky
  private     locked       marked
  urgent      below        normal
  above
]

fn get-node-ids []{
  bspc query -N | each [node-id]{
    instances = [(re:find "instanceName" (bspc query -T -n $node-id))]
    if (== (count $instances) 1) {
      echo $node-id
    }
  }
}

node-jump = [
  first second brother parent
  north west   south   east
]

fn node-path [arg]{
  
  arg-contains-slash = (re:match "/" $arg)
  if $arg-contains-slash {
    # completing JUMPs
    last-slash = [(re:find "/" $arg)][-1][end]
    substr = $arg[0:$last-slash]
    put $substr""$@node-jump"/"
  } else {
    # completing DESKTOP_SEL and first JUMP
    put "@"
    put "@"(desktop:select "")":/"
    put "@"$@node-jump"/"
    put "@."
  }
}

fn verify [arg]{
  re:match "^(.+#)?[0-9a-zA-Z@:/]+(\\.!?[a-z_]+)*$" $arg
}

fn select [arg]{
  ref = ""
  if (re:match "#" $arg) {
    ref = (re:replace "#[^#]*$" "#" $arg)
  }
  arg = (re:replace ".*#" "" $arg)
  ids = [(get-node-ids)]
  desc = [$@descriptors $@ids @]
  
  descriptor = (re:replace "\\..*" '' $arg)

  if (re:match "\\." $arg) {
    # complete modifier(s)
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
  } elif (and (> (count $arg) 0) (==s $arg[0] "@")) {
    put $ref(node-path $arg)
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
