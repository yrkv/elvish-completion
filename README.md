# elvish-completion

WARNING: this framework will probably change significantly very soon.

This is a framework for setting up elvish completion for commands which are very complicated or inconsistent. The main
idea behind it is to have a list of completion maps which are in some way expanded. This is done by having a massive map
for completion of a command. The list begins containing that map, which is then expanded at each argument of the
command. To demonstrate, assume you are making completion for some command that looks something like this:

```
foo [bar|abc|xyz]
```

To do this, you make a map that looks like this:
```
foo0=[ bar abc xyz ]
```

If you want to try this one (or any of them), you can just use the foo completion module.
```
use github.com/yrkv/elvish-completion/foo-completion
```

Simple enough, but what if you want more? Maybe there are subcommands, path completion, or optional parts?

```
foo
  bar [a|b|c]
  abc PATH
  xyz [up|down]
```

Since you can put nest data structures, this is fairly straightforward.

```
foo1=[
  &bar=[ a b c ]
  &abc=[arg]{
    $edit:completion:arg-completer[""] $arg
  }
  &xyz=[ up down ]
]
```

Ok, but what if `foo xyz` takes a `[a|b]` before `[up|down]`?

```
foo
  bar [a|b|c]
  abc PATH
  xyz [a|b] [up|down]
```

This is where the framework reveals both it's inner workings and extensibility.

To create a completion map for it, you need to be able to specify different flags at any point in the map. For even more
complicated completion, you may need to override the default behavior. Both of these are done by adding a special
key/value at that point in the map that contains various variables and "methods".

This is done by using the special key "&&META&&" and specifying everything for that level there. The special key
"&&OPTIONS&&" is needed when we want sequential arguments because we have to give the system a list of stuff to
complete, in order.

"&&OPTIONS&&" can also be used to add a "&&META&&" descriptor into something like a list because elvish doesn't allow
combined lists elements/map pairs.

```
foo2=[
  &bar=[ a b c ]
  &abc=[arg]{
    $edit:completion:arg-completer[""] $arg
  }
  &xyz=[
    &"&&META&&"=[ &ordered=$true ]
    &"&&OPTIONS&&"=[
      [ a b ]
      [ up down ]
    ]
  ]
]
```

Great. But what if the [a|b] should be optional? In other words, that would mean these are the valid possibilities for
the `xyz` subcommand:
```
foo xyz up
foo xyz down
foo xyz a up
foo xyz b up
foo xyz a down
foo xyz b down
```

Then, we need to add a `&&META&&` in the `[a b]` list and make it optional and use `&&OPTIONS&&` to pretend it's still a
list of options.
```
foo3=[
  &bar=[ a b c ]
  &abc=[arg]{
    $edit:completion:arg-completer[""] $arg
  }
  &xyz=[
    &"&&META&&"=[ &ordered=$true ]
    &"&&OPTIONS&&"=[
      [
        &"&&META&&"=[ &optional=$true ]
        &"&&OPTIONS&&"=[ a b ]
      ]
      [ up down ]
    ]
  ]
]
```

A bit verbose, but not too bad.

Finally, what if this command is really horrible with options that take multiple arguments and commands that can be
repeated?

```
foo [OPTIONS] COMMANDS

Options
    -a
    -m [q|w|e|r]
    -d PATH

Command Syntax
    COMMAND [OPTIONS] [PATHS]

Commands
    bar [a|b|c]
    abc PATH
    xyz [[a|b]] [up|down]
    
Command Options
    bar
        -a
        -b

    abc
        --type [[direct|indirect]]
            (direct/indirect is optional here)

    xyz
        --relative
        --some-flag [x|y]
```

How would this monstrosity look like as a completion map?

```
foo4=[
  &"&&META&&"=[ &ordered=$true ]
  &"&&OPTIONS&&"=[
    [
      &"&&META&&"=[
        &optional=$true
        &multiple=$true
      ]
      &-a=$completion:no-arg
      &-m=[ q w e r ]
      &-d=$completion:relative-path
    ]

    [
      &"&&META&&"=[ &multiple=$true ]
      &bar=[
        &"&&META&&"=[ &ordered=$true ]
        &"&&OPTIONS&&"=[
          [
            &"&&META&&"=[
              &optional=$true
              &multiple=$true
            ]
            &"&&OPTIONS&&"=[ -a -b ]
          ]
          [ a b c ]
        ]
      ]

      &abc=[
        &"&&META&&"=[ &ordered=$true ]
        &"&&OPTIONS&&"=[
          [
            &"&&META&&"=[ &optional=$true ]
            &--type=[
              &"&&META&&"=[ &optional=$true ]
              &"&&OPTIONS&&"=[ direct indirect ]
            ]
          ]
          $completion:relative-path
        ]
      ]

      &xyz=[
        &"&&META&&"=[ &ordered=$true ]
        &"&&OPTIONS&&"=[
          [
            &"&&META&&"=[
              &optional=$true
              &multiple=$true
            ]
            &--relative=$completion:no-arg
            &--some-flag=[ x y ]
          ]
          [
            &"&&META&&"=[ &optional=$true ]
            &"&&OPTIONS&&"=[ a b ]
          ]
          [ up down ]
        ]
      ]
    ]
  ]
]
```

This is **very** verbose and ugly. I plan to implement functions that generate this tree to make it less so. 

If these "constructors" were added, you could just write the xyz part like this:

```
      &xyz=(completion:ordered [
        (completion:flags 
          --relative $completion:no-arg
          --some-flag [ x y ]
        )
        (completion:optional [a b])
        [ up down ]
      ])
      
```







