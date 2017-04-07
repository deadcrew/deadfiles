split-stderr() {
    local dir=$(mktemp -d --suffix=.split-stderr)
    local fifo=$dir/fifo
    local pane=$(basename $dir)

    mkfifo "$fifo"

    trap "rm -r $dir" EXIT

    tmux split-window -d "cat $fifo"

    (
        "$@"

        local result=$?

        printf "\n" >/dev/stderr
        printf "\e[1m[%s] finished with exit code %d.\e[0m\n" "$*" "$result" \
            | tee /dev/stderr
        printf "\e[1m\nHit ENTER to finish.\e[0m"

        read
    ) 2>$fifo
}
