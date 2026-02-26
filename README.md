# Completion Supplement

Bash completion files for commands that don't provide them.

## Commands

### =hcron=

Never see =error:missing/bad argument= ever again with this helpful
autocomplete!

### =pandoc=

Pandoc does provide a completion but we have to do
`pandoc --bash-completion > $DIR/bash-completion/completions/_pandoc`
where `$DIR` is one of the paths described in [1].

## Install

### Fool proof way

In your profile, just source every file in `share/bash-completion/completions/*`
with something like

```bash
for f in <THIS-DIR>/share/bash-completion/completions/* ; do
    source $f
done
```

### Proper way

Place the files such that they are in the paths searched by bash-completion
as described in [1].

## References

1. [bash-completion-notes](https://github.com/PhilippeCarphin/manpage-supplement/blob/main/share/man/man7/bash-completion-notes.org)

## Notes
