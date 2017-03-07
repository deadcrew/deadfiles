sed-replace() {
    local from=$(sed 's@/@\\/@g' <<< "$1")
    shift

    local to=""
    if [ $# -ne 0 ]; then
        to=$(sed 's@/@\\/@g' <<< "$1")
        shift
    fi

    local tmpdir=$(mktemp -d)

    if [ $# -ne 0 ]; then
        local diff=false
        local files=()
        for file in $@; do
            if [[ -d "$file" || -x "$file" ]]; then
                continue
            fi

            if [ "$file" = "!" ]; then
                diff=true
            else
                files+=("$file")
            fi
        done

        for file in "${files[@]}"; do
            if $diff; then
                after=$tmpdir/$(basename $file)
                sed -r "s/$from/$to/g" $file >| $after
                if ! cmp -s $file $after; then
                    printf "\e[4m%s\e[0m\n" "$file"
                    diff -u --color=always $file $after \
                        | diff-so-fancy \
                        | tail -n+3
                    printf "\n"
                fi
            else
                sed -ri "s/$from/$to/g" $file
            fi
        done

    else
        sed -r "s/$from/$to/g"
    fi

    rm -rf "$tmpdir"
}

