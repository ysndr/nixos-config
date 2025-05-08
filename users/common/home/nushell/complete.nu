let fish_completer = {|spans|
    # use std/log;
    # log debug $spans

    fish -i --command $'complete "--do-complete=($spans | str join " ")"'
    | from tsv --flexible --noheaders --no-infer
    | rename value description
};

let zoxide_completer = {|spans|
    $spans | skip 1 | zoxide query -l ...$in | lines | where {|x| $x != $env.PWD}
};

# This completer will use fish by default
let external_completer = {|spans|
    # use std/log;

    # log debug $spans

    let expanded_alias = scope aliases
    | where name == $spans.0
    | get -i 0.expansion

    let spans = if $expanded_alias != null {
        $spans
        | skip 1
        | prepend ($expanded_alias | split row ' ' | take 1)
    } else {
        $spans
    }

    let completions = match $spans.0 {
        # fish completes commits and branch names in a nicer way
        git => $fish_completer
        # use zoxide completions for zoxide commands
        __zoxide_z | __zoxide_zi => $zoxide_completer
        _ => $fish_completer
    } | do $in $spans

    if $completions == [] {
        null
    } else {
        $completions
    }    
}


$env.config = ($env.config? | default {})
$env.config.completions = ($env.config.completions? | default {})
$env.config.completions.external = {
    enable: true
    completer: $external_completer
}
