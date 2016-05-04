cd-pkgbuild() {
    local dir=$(basename "$(pwd)")
    if  grep -q '\-pkgbuild' <<< "$dir"; then
        cd ../$(sed -r 's/\-pkgbuild//g' <<< "$dir")
        return
    fi

    local dir_pkgbuild="${dir}-pkgbuild"

    if [ -d "../$dir_pkgbuild" ]; then
        cd "../$dir_pkgbuild"
        return
    fi

    cp -r "../$dir" "../$dir_pkgbuild"

    cd "../$dir_pkgbuild"

    if [ "$(git rev-parse --abbrev-parse HEAD)" = "pkgbuild" ]; then
        return
    fi

    if git branch | grep -q pkgbuild; then
        git checkout pkgbuild
        return
    fi

    git-checkout-orphan pkgbuild
}
