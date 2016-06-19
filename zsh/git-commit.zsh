git-commit() {
    local message="$*"
    local amend=false
    for x in $@; do
        if [ "$x" = "!" ]; then
            amend=true
            message=$(sed-replace ' !' <<< "$message")
        fi
    done

    if ! grep -q ":" <<< "$message"; then
        local changeset=$(git status --porcelain)

        local modified=$(awk '/^M/ { print $2; }' <<< "$changeset")
        local added=$(awk '/^A/ { print $2; }' <<< "$changeset")
        local deleted=$(awk '/^D/ { print $2; }' <<< "$changeset")

        local subject=""

        local pwd=$(pwd)

        if [[ $(pwd) =~ $HOME/dotfiles || $(pwd) =~ $HOME/deadfiles ]]; then
            subject=$(
                echo "$modified" \
                | sed-replace '.*/' \
                | sed-replace '^\.' \
                | sed-replace 'rc$' \
                | sed-replace 'config$' \
                | sed-replace '.conf$'
            )

            if [ ! "$subject" ]; then
                subject=$(
                    echo "$added" \
                    | sed-replace '/.*'
                )
            fi

            if [ ! "$subject" ]; then
                subject=$(
                    echo "$deleted" \
                    | sed-replace '/.*'
                )
            fi
        fi

        if [ "$subject" ]; then
            message="${subject//\\n/, }: $message"
        fi

        unset MATCH
    fi


    local flags=""
    if $amend; then
        flags="--amend"
    fi

    if [ "$(git diff --cached)" = "" ]; then
        git add .
    fi

    git commit $flags -m "$message"
}
