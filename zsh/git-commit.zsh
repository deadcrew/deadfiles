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

        if [ "$subject" ]; then
            subject="${subject//$'\n'/, }"
            message="$subject: $message"
        fi

        unset MATCH
    fi


    local flags="--signoff"
    if $amend; then
        flags="$flags --amend"
    fi

    if [ "$(git diff --cached)" = "" ]; then
        git add .
    fi

    git commit $flags -m "$message"
}
