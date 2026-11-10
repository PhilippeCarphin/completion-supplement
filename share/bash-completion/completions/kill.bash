
# Completion function for kill
#
# This function assumes that you want to kill one of your own processes and
# is therefore inappropriate for admin accounts that would be used to kill
# other user's processes.
#
_kill(){
    local cur prev words cword
    _init_completion || return
    local oifs="${IFS}"

    #
    # Complete options and arguments to options
    #
    case $prev in
        -s) _signals ; return ;;
        -l) return ;;
    esac
    if (( cword == 1 )) && [[ "$cur" == -* ]] ; then
        _signals -
        COMPREPLY+=( $(compgen -W "-s -l" -- "$cur") )
        return
    fi

    #
    # Acquire processes as an array of lines sorted by PID
    # Split lines into PID and CMD while filtering out items whose PID doesn't
    # match '${cur}*'
    #
    IFS=$'\n'
    local lines=($(pgrep -u $USER | xargs ps -h -opid,args))
    IFS="${oifs}"
    local c_pid=()
    local c_desc=()
    for l in "${lines[@]}" ; do
        words=(${l})
        if [[ ${words[0]} != ${cur}* ]] ; then
            continue
        fi
        c_pid+=(${words[0]})
        c_desc+=("${words[*]:1}")  # `words[*]` rather than `words[@]` important
    done

    #
    # Return single candidate or nothing if there is only one
    #
    if (( ${#c_pid[@]} <= 1 )) ; then
        COMPREPLY=(${c_pid})
        return
    fi

    #
    # Obtain maximum string lengths of PIDs and descriptions
    #
    local i max_pid=0 max_desc=0
    for ((i=0;i<${#c_pid[@]};i++)) ; do
        if (( ${#c_pid[i]} > max_pid )) ; then
            max_pid=${#c_pid[i]}
        fi
        if (( ${#c_desc[i]} > max_desc )) ; then
            max_desc=${#c_desc[i]}
        fi
    done

    #
    # Format completion candidates as
    #   '${PID} (${TRUNCATED_DESC})'
    # the same way the completion for Docker and glab do it.
    #
    max_len=$((COLUMNS - max_pid - 4))
    for((i=0;i<${#c_pid[@]};i++)); do
        desc=${c_desc[i]}
        if ((${#desc} > max_len)) ; then
            desc=${desc:0:$((max_len-1))}
            desc+='…'
        fi
        printf -v COMPREPLY[i] "%-${max_pid}s (%s)" "${c_pid[i]}" "${desc}"
    done
}
complete -F _kill kill
