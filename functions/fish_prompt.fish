function fish_prompt
    set -l status_copy $status
    set -l root_glyph " ╍╍ "
    set -l root_color 111 0ff
    set -l pwd_info (pwd_info " ")

    if pwd_is_home
        set root_color 0ff 222
    end

    if test ! -z "$pwd_info[3]"
        segment 0ff 161616 " $pwd_info[3] "
        segment 111 111
    end

    if test ! -z "$pwd_info[1]"
        segment 0ff 222 " $pwd_info[1] "
        segment 111 111
    end

    if set -l branch_name (git_branch_name)
        set -l git_branch_symbol 
        set -l git_branch_symbol_color 0ff 111

        set -l base_color 0ff 222
        set -l dirty_and_staged false

        if git_is_detached_head
            set git_branch_symbol ➟
        end

        if git_is_empty
            set git_branch_symbol_color f00 111
        end

        if git_is_dirty
            set git_branch_symbol_color 111 f00

            if git_is_staged
                set git_branch_symbol_color f00 111
                set dirty_and_staged true
            end
        else if git_is_staged
            set git_branch_symbol_color 111 0ff
        end

        if test "$branch_name" = master
            if git_is_stashed
                set git_branch_symbol "╍"
            end
        else
            set -l repo_status

            if git_is_stashed
                set repo_status "╍"
            end

            segment 0ff 262626 "  $branch_name $repo_status "
            segment 111 111
        end

        if test "$dirty_and_staged" = true
            segment 0ff 111 "$git_branch_symbol "
            segment 111 111
        end

        segment $git_branch_symbol_color " $git_branch_symbol "
        segment 111 111
    end

    if test ! -z "$pwd_info[2]"
        segment 0ff 222 " $pwd_info[2] "
        segment 111 111
    end

    if test ! -z "$SSH_CLIENT"
        segment 0ff 111 (host_info " usr@host ")
        segment 111 111
    end

    if test 0 -eq (id -u $USER)
        set root_color f00 222
    end

    if test "$status_copy" -ne 0
        set root_color 111 f00
    end

    segment $root_color $root_glyph

    set segment (set_color $root_color[2])$segment(set_color normal)

    segment_close
end
