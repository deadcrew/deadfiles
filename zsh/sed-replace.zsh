sed-replace() {
    local from=$(sed 's@/@\\/@g' <<< "$1")
    shift

    local to=""
    if [ $# -ne 0 ]; then
        to=$(sed 's@/@\\/@g' <<< "$1")
        shift
    fi

    if [ $# -ne 0 ]; then
        local diff=false
        local files=()
        for file in $@; do
            if [ "$file" = "!" ]; then
                diff=true
            else
                files+=("$file")
            fi
        done

        for file in "${files[@]}"; do
            if $diff; then
                after=$(mktemp -u)
                sed -r "s/$from/$to/g" $file > $after
                git diff --color $file $after | diff-so-fancy
            else
                sed -ri "s/$from/$to/g" $file
            fi
        done

    else
        sed -r "s/$from/$to/g"
    fi
}

