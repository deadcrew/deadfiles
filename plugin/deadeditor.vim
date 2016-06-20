func! _completions_complete()
    try
        let completions = youcompleteme#OmniComplete(0, 0)
        if len(completions.words) != 1
            return
        endif
    catch
        return
    endtry

    let line = getline('.')
    let col = col('.')
    if col < 2
        return
    endif

    let moresuffix = line[col-4] . line[col-3] . line[col-2] . v:char
    let suffix = line[col-3] . line[col-2] . v:char
    if len(suffix) != 3 || len(moresuffix) != 4
        return
    endif

    let completion = completions.words[0].word
    if matchstr(completion,suffix."$") == "" ||
            \ matchstr(completion,moresuffix."$") != ""
        return
    endif
    call feedkeys("\<C-N>", 'n')
endfunc!
