if !exists('g:env')
        if has('win64') || has('win32') || has('win16')
                let g:env = 'WINDOWS'
        else
                let g:env = toupper(substitute(system('uname'), '\n', '', ''))
        endif
endif

echo g:env

