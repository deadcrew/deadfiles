augroup skeletons
    au!
    au BufNewFile main.go set ft=go.main
    au BufNewFile run_tests.sh,run_tests set ft=sh.test-runner
    au BufNewFile Makefile if system('stat {tests/,}run_tests 2>/dev/null') != "" |
            \ set ft=make.test-runner | endif
augroup END
