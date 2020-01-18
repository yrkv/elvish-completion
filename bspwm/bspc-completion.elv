use re

use github.com/yrkv/elvish-completion/bspwm/selectors/desktop
use github.com/yrkv/elvish-completion/bspwm/selectors/node
use github.com/yrkv/elvish-completion/bspwm/selectors/monitor
use github.com/yrkv/elvish-completion/completion

tree = [
  &bspc= [
    &"&&META&&"= [
      &display-suffix=[
        &quit=" [<status>]"
      ]
    ]
    &config= [
      &"&&META&&"= [
        &ordered=$true
      ]
      &"&&OPTIONS&&"= [
        [
          &"&&META&&"= [
            &optional=$true
            &multiple=$true
          ]
          &"&&OPTIONS&&"= [
            &-m= $monitor:select~
            &-d= $desktop:select~
            &-n= $node:select~
          ]
        ]
        [
          &"&&META&&"= [
            &display-suffix=[
              &normal_border_color=  " #RRGGBB"
              &active_border_color=  " #RRGGBB"
              &focused_border_color= " #RRGGBB"
              &presel_feedback_color=" #RRGGBB"
            ]
          ]
          &normal_border_color=           [arg]{ re:replace "##" '#' "#"$arg }
          &active_border_color=           [arg]{ re:replace "##" '#' "#"$arg }
          &focused_border_color=          [arg]{ re:replace "##" '#' "#"$arg }
          &presel_feedback_color=         [arg]{ re:replace "##" '#' "#"$arg }
          &split_ratio=                   []
          &status_prefix=                 []
          &external_rules_command=        []
          &initial_polarity=              [first_child second_child]
          &directional_focus_tightness=   [high low]
          &borderless_monocle=            [true false]
          &gapless_monocle=               [true false]
          &paddingless_monocle=           [true false]
          &single_monocle=                [true false]
          &pointer_motion_interval=       []
          &pointer_modifier=              [shift control lock mod1 mod2 mod3 mod4 mod5]
          &pointer_action1=               [move resize_side resize_corner focus none]
          &pointer_action2=               [move resize_side resize_corner focus none]
          &pointer_action3=               [move resize_side resize_corner focus none]
          &click_to_focus=                [true false]
          &swallow_first_click=           [true false]
          &focus_follows_pointer=         [true false]
          &pointer_follows_focus=         [true false]
          &pointer_follows_monitor=       [true false]
          &mapping_events_count=          []
          &ignore_ewmh_focus=             [true false]
          &ignore_ewmh_fullscreen=        [arg]{
            opts = [none all enter exit]
            arg = (re:replace "," "" $arg)
            if (eq $arg "enter") {
              put $arg $arg",exit"
            } elif (eq $arg "exit") {
              put $arg $arg",enter"
            } else {
              put $@opts
            }
          }
          &center_pseudo_tiled=           [true false]
          &honor_size_hints=              [true false]
          &remove_disabled_monitors=      [true false]
          &remove_unplugged_monitors=     [true false]
          &merge_overlapping_monitors=    [true false]
          &top_padding=                   []
          &right_padding=                 []
          &bottom_padding=                []
          &left_padding=                  []
          &window_gap=                    []
          &border_width=                  []
        ]
      ]
    ]
    &desktop= [
      &"&&META&&"=[ &ordered=$true ]
      &"&&OPTIONS&&"=[
        $desktop:optional
        [
          &"&&META&&"=[
            &ordered=$true
            &multiple=$true
            &alternatives= [
              &-f=--focus
              &-a=--activate
              &-m=--to-monitor
              &-s=--swap
              &-l=--layout
              &-n=--rename
              &-b=--bubble
              &-r=--remove
            ]
            &display-suffix= [
              &--rename=" <new_name>"
            ]
          ]
          &--focus=    [ $desktop:optional ]
          &--activate= [ $desktop:optional ]
          &--to-monitor= [
            $monitor:select~
            [
              &"&&META&&"= [ &optional=$true ]
              &"&&OPTIONS&&"= [ --follow ]
            ]
          ]
          &--swap= [
            $desktop:select~
            [
              &"&&META&&"= [ &optional=$true ]
              &"&&OPTIONS&&"= [ --follow ]
            ]
          ]
          &--layout= [ next prev monocle tiled ]
          &--rename= [[]]
          &--bubble= [ next prev ]
          &--remove= []
        ]
      ]
    ]
    &monitor= [
      &"&&META&&"=[ &ordered=$true ]
      &"&&OPTIONS&&"=[
        $monitor:optional
        [
          &"&&META&&"=[
            &ordered=$true
            &multiple=$true
            &alternatives=[
              &-f=--focus
              &-s=--swap
              &-a=--add-desktops
              &-o=--reorder-desktops
              &-d=--reset-desktops
              &-g=--rectangle
              &-n=--rename
              &-r=--remove
            ]
            &display-suffix= [
              &--add-desktops=" <name>..."
              &--reorder-desktops=" <name>..."
              &--reset-desktops=" <name>..."
              &--rectangle=" WxH+X+Y"
              &--rename=" <new_name>"
            ]
          ]
          &--focus= [ $monitor:optional ]
          &--swap=  [ $monitor:select~ ]
          &--add-desktops= [
            [
              &"&&META&&"=[ &verify= [@_]{ put $true } ]
              &"&&OPTIONS&&"=[ ]
            ]
          ]
          &--reorder-desktops= [
            [
              &"&&META&&"=[ &verify= [@_]{ put $true } ]
              &"&&OPTIONS&&"=[ ]
            ]
          ]
          &--reset-desktops= [
            $completion:var-args
          ]
          &--rectangle= [
            [
              &"&&META&&"=[ &verify= [arg @_]{ re:match "^(\\d+)x(\\d+)\\+(\\d+)\\+(\\d+)$" $arg } ]
              &"&&OPTIONS&&"=[ ]
            ]
          ]
          &--rename= [[]]
          &--remove= []
        ]
      ]
    ]
    &node= [
      &"&&META&&"=[ &ordered=$true ]
      &"&&OPTIONS&&"=[
        $node:optional
        [
          &"&&META&&"=[
            &ordered=$true
            &multiple=$true
            &alternatives= [
              &-f=--focus
              &-a=--activate
              &-d=--to-desktop
              &-m=--to-monitor
              &-n=--to-node
              &-s=--swap
              &-p=--presel-dir
              &-o=--presel-ratio
              &-v=--move
              &-z=--resize
              &-r=--ratio
              &-R=--rotate
              &-F=--flip
              &-E=--equalize
              &-B=--balance
              &-C=--circulate
              &-t=--state
              &-g=--flag
              &-l=--layer
              &-i=--insert-receptacle
              &-c=--close
              &-k=--kill
            ]
            &display-suffix= [
              &--move=" dx dy"
            ]
          ]
          &--focus=             [ $node:optional ]
          &--activate=          [ $node:optional ]
          &--to-desktop=        [
            $desktop:select~
            [
              &"&&META&&"=[ &optional=$true ]
              &"&&OPTIONS&&"=[ --follow ]
            ]
          ]
          &--to-monitor=        [
            $monitor:select~
            [
              &"&&META&&"=[ &optional=$true ]
              &"&&OPTIONS&&"=[ --follow ]
            ]
          ]
          &--to-node=           [
            $node:select~
            [
              &"&&META&&"=[ &optional=$true ]
              &"&&OPTIONS&&"=[ --follow ]
            ]
          ]
          &--swap=              [
            $node:select~
            [
              &"&&META&&"=[ &optional=$true ]
              &"&&OPTIONS&&"=[ --follow ]
            ]
          ]
          &--presel-dir=        [[arg]{
            opts = [north east south west]
            if (re:match "^~" $arg) {
              put "~"$@opts cancel
            } else {
              put "~" $@opts cancel
            }
          }]
          &--presel-ratio=      [$completion:float]
          &--move=              [
            $completion:check-number~
            $completion:check-number~
          ]
          &--resize=            [
            [top left bottom right top_left top_right bottom_right bottom_left]
            $completion:check-number~
            $completion:check-number~
          ]
          &--ratio=             [[arg]{ put $true }]
          &--rotate=            [[90 270 180]]
          &--flip=              [[horizontal vertical]]
          &--equalize=          []
          &--balance=           []
          &--circulate=         [[forward backward]]
          &--state=             [[arg]{
            opts = [tiled pseudo_tiled floating fullscreen]
            if (re:match "^~" $arg) {
              put "~"$@opts
            } else {
              put "~" $@opts
            }
          }]
          &--flag=              [[hidden sticky private locked=on locked=off]]
          &--layer=             [[below normal above]]
          &--insert-receptacle= []
          &--close=             [[ &"&&META&&"=[ &multiple=$true ] ]]
          &--kill=              [[ &"&&META&&"=[ &multiple=$true ] ]]
        ]
      ]
    ]
    &query= [
      &"&&META&&"= [
        &ordered= $true
        &alternatives= [
          &-N=--nodes
          &-D=--desktops
          &-M=--monitors
          &-T=--tree
        ]
      ]
      &--nodes=     [
        $node:optional
        [
          &"&&META&&"= [
            &multiple=$true
            &alternatives= [
              &-m=--monitor
              &-d=--desktop
              &-n=--node
            ]
          ]
          &--monitor= $monitor:select~
          &--desktop= $desktop:select~
          &--node=    $node:select~
        ]
      ]
      &--desktops=  [
        $desktop:optional
        [
          &"&&META&&"= [
            &multiple=$true
            &alternatives= [
              &-m=--monitor
              &-d=--desktop
              &-n=--node
            ]
          ]
          &--monitor= $monitor:select~
          &--desktop= $desktop:select~
          &--node=    $node:select~
          &--names=   [ &"&&META&&"=[ &optional=$true ] ]
        ]
      ]
      &--monitors=  [
        $monitor:optional
        [
          &"&&META&&"= [
            &multiple=$true
            &alternatives= [
              &-m=--monitor
              &-d=--desktop
              &-n=--node
            ]
          ]
          &--monitor= $monitor:select~
          &--desktop= $desktop:select~
          &--node=    $node:select~
          &--names=   [ &"&&META&&"=[ &optional=$true ] ]
        ]
      ]
      &--tree=      [[
        &"&&META&&"= [
          &multiple=$true
          &alternatives= [
            &-m=--monitor
            &-d=--desktop
            &-n=--node
          ]
        ]
        &--monitor=   $monitor:select~
        &--desktop=   $desktop:select~
        &--node=      $node:select~
      ]]
    ]
    &quit= []
    &rule= [
      &"&&META&&"= [
        &ordered=$true
        &alternatives= [
          &-a=--add
          &-r=--remove
          &-l=--list
        ]
      ]
      &--add=     [
        $completion:any-arg
        [
          &"&&META&&"= (completion:combine-maps $completion:custom-meta[dd-style] [
            &display-suffix=[ &rectangle="WxH+X+Y" ]
            &alternatives= [ &-o=--one-shot ]
          ])
          &--one-shot=    $completion:no-arg
          &monitor=       $monitor:select~
          &desktop=       [arg]{ desktop:select (re:replace ".*=" "" $arg) }
          &node=          [arg]{ node:select (re:replace ".*=" "" $arg) }
          &state=         [tiled pseudo_tiled floating fullscreen]
          &layer=         [below normal above]
          &split_dir=     [north west south east]
          &split_ratio"="=$completion:float

          &hidden=       [on off]
          &sticky=       [on off]
          &private=      [on off]
          &locked=       [on off]
          &center=       [on off]
          &follow=       [on off]
          &manage=       [on off]
          &focus=        [on off]
          &border=       [on off]
          &rectangle"="= []
        ]
      ]
      &--remove=  []
      &--list=    []
    ]
    &subscribe= [
      &"&&META&&"=[
        &ordered=  $true
      ]
      &"&&OPTIONS&&"=[
        [
          &"&&META&&"= [ &optional=$true &alternatives=[&-f=--fifo] ]
          &"&&OPTIONS&&"= [ --fifo ]
        ]
        [
          &"&&META&&"= [
            &optional=$true
            &alternatives=[&-c=--count &-f=--fifo]
          ]
          &--count=[
            &"&&META&&"= [ &verify= [arg @_]{ re:match "^\\d+$" $arg } ]
            &"&&OPTIONS&&"=[ ]
          ]
        ]
        [
          &"&&META&&"= [ &multiple=$true ]
          &all=     $completion:no-arg
          &report=  $completion:no-arg
          &monitor= $completion:no-arg
          &desktop= $completion:no-arg
          &node=    $completion:no-arg
        ]
      ]
    ]
    &wm= [
      &"&&META&&"= [
        &multiple= $true
        &alternatives= [
          &-d=--dump-state
          &-l=--load-state
          &-a=--add-monitor
          &-o=--adopt-orphans
          &-h=--record-history
          &-g=--get-status
        ]
      ]
      &--dump-state=      [ &"&&META&&"=[ &optional=$true ] ]
      &--load-state=      [arg]{ $edit:completion:arg-completer[""] "" }
      &--add-monitor=     [
        &"&&META&&"=[ &ordered=$true ]
        &"&&OPTIONS&&"=[
          $completion:any-arg
          [
            &"&&META&&"=[ &verify= [arg @_]{ re:match "^(\\d+)x(\\d+)\\+(\\d+)\\+(\\d+)$" $arg } ]
            &"&&OPTIONS&&"=[ ]
          ]
        ]
      ]
      &--reorder-monitors=$completion:var-args
      &--adopt-orphans=   $completion:no-arg
      &--record-history=  [on off]
      &--get-status=      $completion:no-arg
    ]
  ]
]
