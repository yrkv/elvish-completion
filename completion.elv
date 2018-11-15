use re
use github.com/yrkv/elvish-completion/completion

debug = $false

fn complete [list @cmd]{
  if (< (count $list) 1) {
    return
  }
  arg = $cmd[0]
  current = $list[0]
  original-current = $current
  meta = (completion:get-meta $current)

  list = $list[1:]

  if (and (eq (kind-of $current) "list") (has-key $current 0) (not (eq (kind-of $current[0]) "string"))) {
    list = [$@current $@list]
    complete $list $@cmd
    return
  }

  if $debug {
    echo "\n\n"
    echo $arg":"
    echo $current
    echo $meta[ordered] $meta[optional] $meta[multiple]
  }
  if (has-key $current "&&OPTIONS&&") {
    if $meta[optional] {
      current = $current["&&OPTIONS&&"]
    } else {
      @next = ($meta[pick-next][switcher] "&&OPTIONS&&" $current $meta)
      list = [$@next $@list]
      complete $list $@cmd
      return
    }
  }
  if $debug {
  	echo $current
  	echo ""
  }

  if (eq 1 (count $cmd)) {
    $meta[complete] $arg $current $meta
    if $meta[optional] {
      complete $list $@cmd
    }
    if $debug {
      echo "\n\n----------LIST----------"
      each [curr]{
        echo $curr
        echo ""
      } $list
    }
  } else {
    verify = ($meta[verify] $arg $current $meta)
    if (not $verify) {
      if (and $meta[optional] (has-key $list 0)) {
        complete $list $@cmd
        return
      }
      fail "unable to match arg: "$arg
    }
    @next = ($meta[pick-next][switcher] $arg $current $meta)
    if (and $meta[multiple] $meta[optional]) {
      next[-1] = $original-current
    }
    list = [$@next $@list]
    complete $list (explode $cmd[1:])
  }
}

fn completer [completion-map cmd]{
  complete [$completion-map] $@cmd
}







fn get-alt-key [key alternatives]{
  if (has-key $alternatives $key) {
    key = $alternatives[$key]
  }
  put $key
}

fn combine-maps [old new]{
  each [key]{
    old[$key] = $new[$key]
  } [(keys $new)]
  put $old
}

fn get-meta [current]{
  meta = $completion:default-meta

  new = $meta
  if (has-key $current "&&META&&") {
    try {
      new = $current["&&META&&"]
    } except {

    }
  }

  put (completion:combine-maps $meta $new)
}

fn check-number [arg]{
  find = [(re:find "-?[0-9]+(.[0-9]+)?" $arg)]
  if (!= 1 (count $find)) {
    put $false; return
  }
  find = $find[0]

  put (and (== $find[start] 0) (== $find[end] (count $arg)))
}

fn make-complex-candidate [key candidate meta]{
  # set defaults
  display-suffix = ""
  code-suffix = ""
  style = ""

  # check meta for values
  if (has-key $meta[display-suffix] $key) { display-suffix=$meta[display-suffix][$key] }
  if (has-key $meta[code-suffix] $key) { code-suffix=$meta[code-suffix][$key] }
  if (has-key $meta[style] $key) { style=$meta[style][$key] }

  #create output
  edit:complex-candidate $candidate \
    &display-suffix=$display-suffix \
    &code-suffix=$code-suffix \
    &style=$style
}

fn noverify [@_]{
  put $true
}



# default options for a completion argument. Applies to options
# at the same level as this definition.
#   ordered:      Accepts a list of separate completion targets, in order.
#                 The system completes every element of the list separately.
#                   e.g. "bspc node --resize DIR dx dy" would require that the
#                   "--resize" option has a list with 3 elements for completion.
#   
#   multiple:     Complete the keys/values multiple times. 
#                 in something like dd, you want to configure it to $true.
#                   e.g. "dd if=... of=... status=...".
#
#   alternatives: Specify which keys have multiple names (long and short)
#                   e.g. "ls -a" vs "ls --all" would mean you could do:
#                   $alternatives = [&-a=--all]
#
#   get-key:      function to convert the {last} argument to the key.
#                 Useful to make the separator be something like "="
#
#   apply:        function in between the discovered candidates and the output candidates.
#                 Useful to make the separator be something like "="

default-meta = [
  &ordered=       $false
  &multiple=      $false
  &optional=      $false

  &complete-options-on-dash= $true

  &alternatives=  [&]

  &display-suffix=[&]
  &code-suffix=[&]
  &style=[&]

  &get-options=   [arg current meta]{
    kind = (kind-of $current)
    if (eq $kind "map") {
      keys $current | peach [key]{ if (not (re:match "^&&[A-Z]+&&$" $key)) { put $key } }
    } elif (eq $kind "list") {
      explode $current
    } elif (eq $kind "fn") {
      $current $arg
    }
  }

  &pick-next= [
    &switcher= [arg current meta]{
      if (eq (kind-of $current) "map") {
        if $meta[ordered] {
          $meta[pick-next][ordered] $arg $current $meta
        } else {
          $meta[pick-next][normal] $arg $current $meta
        }
        if $meta[multiple] {
          put $current
        }
      }
    }
    &normal= [arg current meta]{
      key = ($meta[get-key] $arg $meta)
      next = $current[$key]
      put $next
    }
    &ordered= [arg current meta]{
      key = ($meta[get-key] $arg $meta)
      next = $current[$key]
      explode $next
    }
  ]

  &get-key=       [arg meta]{
    put (get-alt-key $arg $meta[alternatives])
  }

  &apply=         [arg candidates current meta]{
    put $@candidates | peach [candidate]{
      if (eq (kind-of $candidate) "string") {
        if (and $meta[complete-options-on-dash] (re:match "^-" $candidate) (not (re:match "^-" $arg))) {
          # if set that way, only complete "-" options if the arg starts with "-"
          continue
        }
        key = ($meta[get-key] $candidate $meta)
        make-complex-candidate $key $candidate $meta
      } elif (has-key $candidate "style") { # crappy way to check if it's already a complex-candidate
        put $candidate
      }
    }
  }

  &verify=        [arg current meta]{
    @opts = ($meta[get-options] $arg $current $meta)
    key = ($meta[get-key] $arg $meta)
    val = (has-value $opts $key)
    if (eq (kind-of $current) "fn") {
      or $val ($current $arg)
    } else {
      put $val
    }
  }

  &complete=      [arg current meta]{
    @candidates = ($meta[get-options] $arg $current $meta)
    $meta[apply] $arg $candidates $current $meta
  }
]




# custom "modules" to be used in completion definitions

var-args = [
  &"&&META&&"= [
    &multiple= $true
    &get-key= [@_]{ put "" }
    &verify= $completion:noverify~
    &complete= [@_]{ }
  ]
  &""= [ &"&&META&&"=[ &optional=$true ] ]
]

any-arg = [
  &"&&META&&"= [
    &get-key= [@_]{ put "" }
    &verify= $completion:noverify~
    &complete= [@_]{ }
  ]
  &""= [ &"&&META&&"=[ &optional=$true ] ]
]

no-arg = [
  &"&&META&&"=[ &optional=$true ]
]

integer = [
  &"&&META&&"= [
    &get-key= [@_]{ put "" }
    &verify= [arg current meta]{
      re:match "^\\d+$" $arg
    }
    &complete= [@_]{ }
  ]
  &""= [ &"&&META&&"=[ &optional=$true ] ]
]

float = [
  &"&&META&&"= [
    &get-key= [@_]{ put "" }
    &verify= [arg current meta]{
      re:match "^(\\d*.)?\\d+$" $arg
    }
    &complete= [@_]{ }
  ]
  &""= [ &"&&META&&"=[ &optional=$true ] ]
]

absolute-path = [arg]{
  if (not (re:match "^/" $arg)) {
    arg = "/"$arg
  }
  $edit:completion:arg-completer[""] $arg
}

relative-path = [arg]{
  $edit:completion:arg-completer[""] $arg
}


#TODO: redo this type to continue completion into after the =
custom-meta = [
  &dd-style= [
    &multiple=$true
    &display-suffix=[ &rectangle="WxH+X+Y" ]
    &alternatives= [ &-o=--one-shot ]
    &get-key= [arg meta]{
      key = (re:replace "=.*" "" $arg)
      key = ($completion:default-meta[get-key] $key $meta)
      put $key
    }
    &pick-next= [
      &switcher= [arg current meta]{ put $current }
      &normal= [arg current meta]{ }
      &ordered= [arg current meta]{ }
    ]
    &apply= [arg candidates current meta]{
      $completion:default-meta[apply] $arg $candidates $current $meta
      key = ($meta[get-key] $arg $meta)
      before-equals = (re:replace ".*=" "" $arg)
      after-equals = (re:replace "=.*" "" $arg)
      if (has-key $current $key) {
        @opts = ($meta[get-options] $before-equals $current[$key] (completion:get-meta [&]))
        for opt $opts {
          if (eq (kind-of $opt) "string") { 
            candidate = $after-equals"="$opt
            completion:make-complex-candidate $key $candidate $meta
          } elif (has-key $opt "style") { # crappy way to check if it's already a complex-candidate
            candidate = $after-equals"="$opt[stem]""$opt[code-suffix]
            completion:make-complex-candidate $key $candidate $meta
          }
        }
      }
    }
    &verify=        [arg current meta]{
      or (re:match '^[a-z_]+=' $arg) ($default-meta[verify] $arg $current $meta)
    }
  ]
]










