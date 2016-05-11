:include-deadfiles() {
    local self=$1
    local file

    for file in $(readlink -f "$(dirname "$self")")/zsh/*.zsh; do
        source "$file"
    done
}

:include-deadfiles "$0"
