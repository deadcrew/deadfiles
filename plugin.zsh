for file in $(readlink -f "$(dirname "$0")")/zsh/*.zsh; do
    source "$file"
done
