use github.com/yrkv/elvish-completion/completion

use re

#TODO: make dd-style and regular options mixable (need to override part of the switcher maybe)
#TODO: make completion for the various git commands
tree = [
  &"&&META&&"=[
    &ordered=$true
  ]
  &git=[
    [
      &"&&META&&"=[
        &multiple=$true
        &optional=$true
        &complete-options-on-dash=$true
        &alternatives=[
          &-p=--paginate
          &-P=--no-pager
        ]
        &display-suffix=[
          &-C=" <path>"
          &-c=" <name>=<value>"
          &--exec-path="[=<path>]"
          &--git-dir=     "=<path>"
          &--work-tree=   "=<path>"
          &--namespace=   "=<path>"
          &--super-prefix="=<path>"
          &--list-cmds="=group[,group...]"
        ]
        &code-suffix=[
          &--git-dir=     "="
          &--work-tree=   "="
          &--namespace=   "="
          &--super-prefix="="
          &--list-cmds=   "="
        ]
        &get-key= [arg meta]{
          key = (re:replace "=.*" "" $arg)
          key = ($completion:default-meta[get-key] $key $meta)
          put $key
        }
      ]
      &--version=[]
      &--help=[]
      &-C=$completion:relative-path
      &-c=$completion:any-arg
      &--exec-path=$completion:no-arg
      &--html-path=[]
      &--man-path=[]
      &--info-path=[]
      &--paginate=$completion:no-arg
      &--no-pager=$completion:no-arg
      &--git-dir=$completion:no-arg
      &--work-tree=$completion:no-arg
      &--namespace=$completion:no-arg
      &--super-prefix=$completion:no-arg
      &--bare=$completion:no-arg
      &--no-replace-objects=$completion:no-arg
      &--literal-pathspecs= $completion:no-arg
      &--glob-pathspecs=    $completion:no-arg
      &--noglob-pathspecs=  $completion:no-arg
      &--icase-pathspecs=   $completion:no-arg
      &--list-cmds=         $completion:no-arg
    ]

    [
      &"&&META&&"=[
        &display-suffix=[
          &add="      - Add file contents to the index."
          &bisect="   - Use binary search to find the commit that introduced a bug."
          &branch="   - List, create, or delete branches."
          &checkout=" - Switch branches or restore working tree files."
          &clone="    - Clone a repository into a new directory."
          &commit="   - Record changes to the repository."
          &diff="     - Show changes between commits, commit and working tree, etc."
          &fetch="    - Download objects and refs from another repository."
          &grep="     - Print lines matching a pattern."
          &help="     - Display help information about Git."
          &init="     - Create an empty Git repository or reinitialize an existing one."
          &log="      - Show commit logs."
          &merge="    - Join two or more development histories together."
          &mv="       - Move or rename a file, a directory, or a symlink."
          &pull="     - Fetch from and integrate with another repository or a local branch."
          &push="     - Update remote refs along with associated objects."
          &rebase="   - Reapply commits on top of another base tip."
          &reset="    - Reset current HEAD to the specified state."
          &rm="       - Remove files from the working tree and from the index."
          &show="     - Show various types of objects."
          &status="   - Show the working tree status."
          &tag="      - Create, list, delete or verify a tag object signed with GPG."
        ]
      ]

      &clone=     $completion:var-args
      &init=      $completion:var-args

      &add=[
        &"&&META&&"=[ &multiple=$true ]
        &"&&OPTIONS&&"=$completion:relative-path
      ]
      &mv=        $completion:var-args
      &reset=     $completion:var-args
      &rm=        $completion:var-args

      &bisect=    $completion:var-args
      &grep=      $completion:var-args
      &log=       $completion:var-args
      &show=      $completion:var-args
      &status=    $completion:var-args

      &branch=    $completion:var-args
      &checkout=  $completion:var-args
      &commit=    $completion:var-args
      &diff=      $completion:var-args
      &merge=     $completion:var-args
      &rebase=    $completion:var-args
      &tag=       $completion:var-args

      &fetch=     $completion:var-args
      &pull=      $completion:var-args
      &push=      $completion:var-args

      &help=      $completion:var-args
    ]
  ]
]
