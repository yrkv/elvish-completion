use github.com/yrkv/elvish-completion/completion
use str
use re

fn get-channels []{
  nix-channel --list | peach [line]{
    @split = (splits " " $line)
    split[1] = (re:replace ".*/" "" $split[1])
    edit:complex-candidate $split[0] &display-suffix=$split[1]
  }
}

tree = [
  &"&&META&&"=[
    &
  ]
  &nix-channel= [
    &--add=$completion:var-args
    &--remove=[arg]{
      #get-channels
    }
    &--list=$completion:no-arg
    &--update=[arg]{
      get-channels
    }
    &--rollback=$completion:no-arg
  ]
]
