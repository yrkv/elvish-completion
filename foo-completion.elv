use github.com/yrkv/elvish-completion/completion

tree = [
  &foo0=[ bar abc xyz ]
  &foo1=[
    &bar=[ a b c ]
    &abc=[arg]{
      $edit:completion:arg-completer[""] $arg
    }
    &xyz=[ up down ]
  ]
  &foo2=[
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
  &foo3=[
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
  &foo4=[
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
]

edit:completion:arg-completer[foo0] = [@cmd]{ completion:completer $tree $cmd }
edit:completion:arg-completer[foo1] = [@cmd]{ completion:completer $tree $cmd }
edit:completion:arg-completer[foo2] = [@cmd]{ completion:completer $tree $cmd }
edit:completion:arg-completer[foo3] = [@cmd]{ completion:completer $tree $cmd }
edit:completion:arg-completer[foo4] = [@cmd]{ completion:completer $tree $cmd }
