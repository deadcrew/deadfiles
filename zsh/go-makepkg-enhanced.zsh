go-makepkg-enhanced() {
    if [ "$1" = "-h" ]; then
        echo "package description [repo]"
        return
    fi

    local package="$1"
    local description="$2"
    local repo="$3"
    shift 2

    if [ "$repo" ]; then
        shift
    else
        repo=$(git remote get-url origin)
        if grep -q "github.com" <<< "$repo"; then
            repo=$(sed-replace '.*@' 'git://' <<< "$repo")
            repo=$(sed-replace '.*://' 'git://' <<< "$repo")
        fi
    fi

    go-makepkg -g -c -n "$package" -d . $(echo $FLAGS) "$description" "$repo" $@
}
