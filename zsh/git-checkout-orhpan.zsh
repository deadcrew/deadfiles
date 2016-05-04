git-checkout-orphan() {
    git checkout --orphan "$1"
    git status -s | awk '{print $2}' | xargs -n1 rm -rf
    git add .
}
