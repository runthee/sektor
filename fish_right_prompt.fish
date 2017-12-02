function fish_right_prompt
    set -l status_copy $status
    set -l status_code $status_copy
    set -l status_color 0ff
    set -l status_glyph │

    switch "$status_copy"
        case 0 "$__sektor_status_last"
            set status_code
    end

    set -g __sektor_status_last $status_copy

    if test "$status_copy" -ne 0
        set status_color f00
    end

    set __cmd_duration $CMD_DURATION 0
    if test "$__cmd_duration" -gt 100
        if test ! -z "$status_code"
            echo -sn (set_color $status_color) "$status_code ╱" (set_color normal)
        end

        set -l duration (echo $__duration | humanize_duration)
        echo -sn (set_color $status_color) " $duration " (set_color normal)
        set status_glyph ┃
    else
        if test ! -z "$status_code"
            echo -sn (set_color $status_color) "$status_code " (set_color normal)
            set status_glyph ┃
        end
    end

    if set -l job_id (last_job_id -l) > /dev/null
        set status_glyph "٪$job_id $status_glyph"
    end

    echo -sn (set_color $status_color) "$status_glyph" (set_color normal)
end
