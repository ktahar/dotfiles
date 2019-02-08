if exists('b:did_ftplugin_tex_my')
    finish
endif
let b:did_ftplugin_tex_my = 1

setl fileencoding=utf-8
setl tabstop=2 expandtab shiftwidth=2 softtabstop=2
setl iskeyword+=:

" mathzone align from amsmath.sty.
call TexNewMathZone("N", "align", 0)

" Script below from TeXWiki/Vim/tex.vim.
" Modified to use local variables, mappings and command definitions.

if has('win32') || has('win64')
  let s:typeset = 'pdfuplatex'
  let s:viewer = 'sumatrapdf'
elseif has('macunix')
  let s:typeset = 'pdfuplatex'
  let s:viewer = 'skim'
else
  let s:typeset = 'pdfuplatex'
  let s:viewer = 'fwdevince'
endif

" Set TeXmaster only if it doesn't exist
if !exists("s:master")
    let s:master = expand("%:t")
endif

function! s:TypesetFile()
  if &ft != 'tex'
    echo "calling TeXworks from a non-tex file"
    return ''
  end

  if s:typeset == 'pdfuplatex'
    call s:PdfupLaTeX("pdfuplatex")
  elseif s:typeset == 'pdfuplatex2'
    call s:PdfupLaTeX("pdfuplatex2")
  elseif s:typeset == 'pdflatex'
    call s:PdfLaTeX("pdflatex")
  elseif s:typeset == 'lualatex'
    call s:PdfLaTeX("lualatex")
  elseif s:typeset == 'luajitlatex'
    call s:PdfLaTeX("luajitlatex")
  elseif s:typeset == 'xelatex'
    call s:PdfLaTeX("xelatex")
  elseif s:typeset == 'latexmk'
    call s:Latexmk("default", 0)
  else
    call s:PdfupLaTeX("pdfuplatex")
  endif
  return ''
endfunction

function! s:ViewFile()
  if &ft != 'tex'
    echo "calling TeXworks from a non-tex file"
    return ''
  end

  if s:viewer == 'sumatrapdf'
    call s:SumatraPDF()
  elseif s:viewer == 'fwdsumatrapdf'
    call s:FwdSumatraPDF()
  elseif s:viewer == 'texworks'
    call s:TeXworks()
  elseif s:viewer == 'preview'
    call s:Preview()
  elseif s:viewer == 'texshop'
    call s:TeXShop()
  elseif s:viewer == 'skim'
    call s:Skim()
  elseif s:viewer == 'evince'
    call s:Evince()
  elseif s:viewer == 'fwdevince'
    call s:FwdEvince()
  elseif s:viewer == 'okular'
    call s:Okular()
  elseif s:viewer == 'zathura'
    call s:Zathura()
  elseif s:viewer == 'qpdfview'
    call s:Qpdfview()
  elseif s:viewer == 'acroread'
    call s:AdobeAcrobatReaderDC()
  endif
  return ''
endfunction

function! s:SetViewer(viewer)
  if has('win32') || has('win64')
    if a:viewer == 'texworks'
      let s:viewer = 'texworks'
    elseif a:viewer == 'sumatrapdf'
      let s:viewer = 'sumatrapdf'
    elseif a:viewer == 'fwdsumatrapdf'
      let s:viewer = 'fwdsumatrapdf'
    elseif a:viewer == 'acroread'
      let s:viewer = 'acroread'
    else
      let s:viewer = 'texworks'
    endif
  elseif has('macunix')
    if a:viewer == 'preview'
      let s:viewer = 'preview'
    elseif a:viewer == 'texshop'
      let s:viewer = 'texshop'
    elseif a:viewer == 'texworks'
      let s:viewer = 'texworks'
    elseif a:viewer == 'skim'
      let s:viewer = 'skim'
    elseif a:viewer == 'acroread'
      let s:viewer = 'acroread'
    else
      let s:viewer = 'preview'
    endif
  else
    if a:viewer == 'evince'
      let s:viewer = 'evince'
    elseif a:viewer == 'fwdevince'
      let s:viewer = 'fwdevince'
    elseif a:viewer == 'texworks'
      let s:viewer = 'texworks'
    elseif a:viewer == 'okular'
      let s:viewer = 'okular'
    elseif a:viewer == 'zathura'
      let s:viewer = 'zathura'
    elseif a:viewer == 'qpdfview'
      let s:viewer = 'qpdfview'
    elseif a:viewer == 'acroread'
      let s:viewer = 'acroread'
    else
      let s:viewer = 'evince'
    endif
  endif
endfunction

function! s:SetTypeset(type)
  if a:type == 'pdfuplatex'
    let s:typeset = 'pdfuplatex'
  elseif a:type == 'pdfuplatex2'
    let s:typeset = 'pdfuplatex2'
  elseif a:type == 'pdflatex'
    let s:typeset = 'pdflatex'
  elseif a:type == 'lualatex'
    let s:typeset = 'lualatex'
  elseif a:type == 'luajitlatex'
    let s:typeset = 'luajitlatex'
  elseif a:type == 'xelatex'
    let s:typeset = 'xelatex'
  elseif a:type == 'latexmk'
    let s:typeset = 'latexmk'
  else
    let s:typeset = 'pdfuplatex'
  endif
endfunction

function! s:SetTeXmaster(master)
  if a:master != ''
    let s:master = a:master
    call s:EchoTeXmaster()
  endif
endfunction

function! s:SetTeXmasterCurrent()
  let s:master = expand("%:t")
  call s:EchoTeXmaster()
endfunction

function! s:EchoTeXmaster()
  echo "TeXmaster: " . s:master
endfunction

function! s:PdfupLaTeX(type)
  if &ft != 'tex'
    echo "calling PdfupLaTeX from a non-tex file"
    return ''
  end

  w

  let masterDir = expand("%:p:h")
  let masterTeXFile = s:master
  let masterBaseName = fnamemodify(masterTeXFile, ":t:r")
  if a:type == 'pdfuplatex'
    if has('win32') || has('win64')
      let ptex2pdf = 'ptex2pdf -u -l -ot "-synctex=1 -no-guess-input-enc -kanji=utf8 -sjis-terminal"' . ' "' . masterTeXFile . '"'
      if s:viewer == 'acroread'
        let pdfclose = 'tasklist /fi "IMAGENAME eq AcroRd32.exe" /nh | findstr "AcroRd32.exe" > nul && echo exit | pdfdde --r15'
        let execString = 'cd /d ' . masterDir . ' && ' . pdfclose . ' & ' . ptex2pdf
      else
        let execString = 'cd /d ' . masterDir . ' && ' . ptex2pdf
      endif
    else
      let ptex2pdf = 'ptex2pdf -u -l -ot "-synctex=1"' . ' "' . masterTeXFile . '"'
      let execString = 'cd ' . masterDir . ' && ' . ptex2pdf
    endif
  elseif a:type == 'pdfuplatex2'
    if has('win32') || has('win64')
      let latex = 'uplatex -synctex=1 -no-guess-input-enc -kanji=utf8 -sjis-terminal' . ' "' . masterTeXFile . '"'
      let dvips = 'dvips -Ppdf -z -f' . ' "' . masterBaseName . '.dvi"' . ' | convbkmk -u > "' . masterBaseName . '.ps"'
      let ps2pdf = 'ps2pdf.exe' . ' "' . masterBaseName . '.ps"'
      if s:viewer == 'acroread'
        let pdfclose = 'tasklist /fi "IMAGENAME eq AcroRd32.exe" /nh | findstr "AcroRd32.exe" > nul && echo exit | pdfdde --r15'
        let execString = 'cd /d ' . masterDir . ' && ' . pdfclose . ' & ' . latex . ' && ' . dvips . ' && ' . ps2pdf
      else
        let execString = 'cd /d ' . masterDir . ' && ' . latex . ' && ' . dvips . ' && ' . ps2pdf
      endif
    else
      let latex = 'uplatex -synctex=1' . ' "' . masterTeXFile . '"'
      let dvips = 'dvips -Ppdf -z -f' . ' "' . masterBaseName . '.dvi"' . ' | convbkmk -u > "' . masterBaseName . '.ps"'
      let ps2pdf = 'ps2pdf' . ' "' . masterBaseName . '.ps"'
      let execString = 'cd ' . masterDir . ' && ' . latex . ' && ' . dvips . ' && ' . ps2pdf
    endif
  endif

  execute 'lcd ' . masterDir
  execute '!' execString
  "execute 'silent! !' execString
  redraw!
  return ''
endfunction

function! s:PdfLaTeX(type)
  if &ft != 'tex'
    echo "calling PdfLaTeX from a non-tex file"
    return ''
  end

  w

  let masterDir = expand("%:p:h")
  let masterTeXFile = s:master
  let masterBaseName = fnamemodify(masterTeXFile, ":t:r")
  if a:type == 'pdflatex'
    let pdflatex = 'pdflatex -synctex=1' . ' "' . masterTeXFile . '"'
  elseif a:type == 'lualatex'
    let pdflatex = 'lualatex -synctex=1' . ' "' . masterTeXFile . '"'
  elseif a:type == 'luajitlatex'
    let pdflatex = 'luajitlatex -synctex=1' . ' "' . masterTeXFile . '"'
  elseif a:type == 'xelatex'
    let pdflatex = 'xelatex -synctex=1' . ' "' . masterTeXFile . '"'
  endif

  if has('win32') || has('win64')
    if s:viewer == 'acroread'
      let pdfclose = 'tasklist /fi "IMAGENAME eq AcroRd32.exe" /nh | findstr "AcroRd32.exe" > nul && echo exit | pdfdde --r15'
      let execString = 'cd /d ' . masterDir . ' && ' . pdfclose . ' & ' . pdflatex
    else
      let execString = 'cd /d ' . masterDir . ' && ' . pdflatex
    endif
  else
    let execString = 'cd ' . masterDir . ' && ' . pdflatex
  endif

  execute 'lcd ' . masterDir
  execute '!' execString
  "execute 'silent! !' execString
  redraw!
  return ''
endfunction

function! s:Latexmk(type, silent, clean)
  if &ft != 'tex'
    echo "calling Latexmk from a non-tex file"
    return ''
  end

  w

  let masterDir = expand("%:p:h")
  let masterTeXFile = s:master
  let masterBaseName = fnamemodify(masterTeXFile, ":t:r")

  let l:opts = ''
  if a:type == 'pdf'
      let l:opts = l:opts . ' -pdf'
  endif

  if a:clean
      let l:opts = l:opts . ' -gg'
  endif

  let latexmk = 'latexmk' . l:opts . ' "' . masterTeXFile . '"'

  if has('win32') || has('win64')
    if s:viewer == 'acroread'
      let pdfclose = 'tasklist /fi "IMAGENAME eq AcroRd32.exe" /nh | findstr "AcroRd32.exe" > nul && echo exit | pdfdde --r15'
      let execString = 'cd /d ' . masterDir . ' && ' . pdfclose . ' & ' . latexmk
    else
      let execString = 'cd /d ' . masterDir . ' && ' . latexmk
    endif
  else
    let execString = 'cd ' . masterDir . ' && ' . latexmk
  endif

  execute 'lcd ' . masterDir
  if a:silent
    execute 'silent! !' execString
  else
    execute '!' execString
  endif
  redraw!
  return ''
endfunction

function! s:TeXworks()
  if &ft != 'tex'
    echo "calling TeXworks from a non-tex file"
    return ''
  end

  let masterDir = expand("%:p:h")
  let masterTeXFile = s:master
  let masterPDFFile = fnamemodify(masterTeXFile, ":t:r") . '.pdf'
  if has('win32') || has('win64')
    if glob('C:/w32tex/share/texworks/TeXworks.exe') != ''
      let viewer = '"' . glob('C:/w32tex/share/texworks/TeXworks.exe') . '"'
    elseif glob('C:/texlive/*/tlpkg/texworks/texworks.exe') != ''
      let viewer = '"' . glob('C:/texlive/*/tlpkg/texworks/texworks.exe') . '"'
    else
      let viewer = 'TeXworks.exe'
    endif
    let execString = 'cd /d ' . masterDir . ' && echo ' . viewer . ' "' . masterPDFFile . '" | cmd'
  elseif has('macunix')
    let viewer = 'open -a TeXworks.app'
    let execString = 'cd ' . masterDir . ' && ' . viewer . ' "' . masterPDFFile . '" &'
  else
    let viewer = 'texworks'
    let execString = 'cd ' . masterDir . ' && ' . viewer . ' "' . masterPDFFile . '" &'
  endif

  execute 'lcd ' . masterDir
  execute 'silent! !' execString
  redraw!
  return ''
endfunction

function! s:SumatraPDF()
  if &ft != 'tex'
    echo "calling SumatraPDF from a non-tex file"
    return ''
  end

  let masterDir = expand("%:p:h")
  let currentTeXFile = expand("%:t")
  let masterTeXFile = s:master
  let masterPDFFile = fnamemodify(masterTeXFile, ":t:r") . '.pdf'
  if has('win32') || has('win64')
    if glob('C:/Program Files/SumatraPDF/SumatraPDF.exe') != ''
      let viewer = '"' . glob('C:/Program Files/SumatraPDF/SumatraPDF.exe') . '"'
    elseif glob('C:/Program Files (x86)/SumatraPDF/SumatraPDF.exe') != ''
      let viewer = '"' . glob('C:/Program Files (x86)/SumatraPDF/SumatraPDF.exe') . '"'
    else
      let viewer = 'rundll32 shell32,ShellExec_RunDLL SumatraPDF'
    endif
    let execString = 'cd /d ' . masterDir . ' && echo ' . viewer . ' -reuse-instance -inverse-search "\"' . $VIM . '\gvim.exe\" -n --remote-silent +\%l \"\%f\"" "' . masterPDFFile . '" -forward-search "' . currentTeXFile . '" ' . line(".") . ' | cmd'
  endif

  execute 'lcd ' . masterDir
  execute 'silent! !' execString
  redraw!
  return ''
endfunction

function! s:FwdSumatraPDF()
  if &ft != 'tex'
    echo "calling FwdSumatraPDF from a non-tex file"
    return ''
  end

  let masterDir = expand("%:p:h")
  let currentTeXFile = expand("%:t")
  let masterTeXFile = s:master
  let masterPDFFile = fnamemodify(masterTeXFile, ":t:r") . '.pdf'
  if has('win32') || has('win64')
    let viewer = 'fwdsumatrapdf'
    let execString = 'cd /d ' . masterDir . ' && ' . viewer . ' "' . masterPDFFile . '" "' . currentTeXFile . '" ' . line(".")
  endif

  execute 'lcd ' . masterDir
  execute 'silent! !' execString
  redraw!
  return ''
endfunction

function! s:Preview()
  if &ft != 'tex'
    echo "calling Preview from a non-tex file"
    return ''
  end

  let masterDir = expand("%:p:h")
  let masterTeXFile = s:master
  let masterPDFFile = fnamemodify(masterTeXFile, ":t:r") . '.pdf'
  let viewer = 'open -a Preview.app'
  let execString = 'cd ' . masterDir . ' && ' . viewer . ' "' . masterPDFFile . '" &'

  execute 'lcd ' . masterDir
  execute 'silent! !' execString
  redraw!
  return ''
endfunction

function! s:TeXShop()
  if &ft != 'tex'
    echo "calling TeXShop from a non-tex file"
    return ''
  end

  let masterDir = expand("%:p:h")
  let masterTeXFile = s:master
  let masterPDFFile = fnamemodify(masterTeXFile, ":t:r") . '.pdf'
  let viewer = 'open -a TeXShop.app'
  let execString = 'cd ' . masterDir . ' && ' . viewer . ' "' . masterPDFFile . '" &'

  execute 'lcd ' . masterDir
  execute 'silent! !' execString
  redraw!
  return ''
endfunction

function! s:Skim()
  if &ft != 'tex'
    echo "calling Skim from a non-tex file"
    return ''
  end

  let masterDir = expand("%:p:h")
  let currentTeXFile = expand("%:t")
  let masterTeXFile = s:master
  let masterPDFFile = fnamemodify(masterTeXFile, ":t:r") . '.pdf'
  let viewer = '/Applications/Skim.app/Contents/SharedSupport/displayline'
  let execString = 'cd ' . masterDir . ' && ' . viewer . ' ' . line(".") . ' "' . masterPDFFile . '" "' . currentTeXFile . '" &'

  execute 'lcd ' . masterDir
  execute 'silent! !' execString
  redraw!
  return ''
endfunction

function! s:Evince()
  if &ft != 'tex'
    echo "calling Evince from a non-tex file"
    return ''
  end

  let masterDir = expand("%:p:h")
  let masterTeXFile = s:master
  let masterPDFFile = fnamemodify(masterTeXFile, ":t:r") . '.pdf'
  let viewer = 'evince'
  let execString = 'cd ' . masterDir . ' && ' . viewer . ' "' . masterPDFFile . '" &'

  execute 'lcd ' . masterDir
  execute 'silent! !' execString
  redraw!
  return ''
endfunction

function! s:FwdEvince()
  if &ft != 'tex'
    echo "calling FwdEvince from a non-tex file"
    return ''
  end

  let masterDir = expand("%:p:h")
  let currentTeXFile = expand("%:t")
  let masterTeXFile = s:master
  let masterPDFFile = fnamemodify(masterTeXFile, ":t:r") . '.pdf'
  let viewer = 'fwdevince'
  let execString = 'cd ' . masterDir . ' && ' . viewer . ' "' . masterPDFFile . '" ' . line(".") . ' "' . currentTeXFile . '" &'

  execute 'lcd ' . masterDir
  execute 'silent! !' execString
  redraw!
  return ''
endfunction

function! s:Okular()
  if &ft != 'tex'
    echo "calling Okular from a non-tex file"
    return ''
  end

  let masterDir = expand("%:p:h")
  let currentTeXFile = expand("%:p")
  let masterTeXFile = s:master
  let masterPDFFile = fnamemodify(masterTeXFile, ":t:r") . '.pdf'
  let viewer = 'okular'
  let execString = 'cd ' . masterDir . ' && ' . viewer . ' --unique "file:' . masterPDFFile . '\#src:' . line(".") . ' ' . currentTeXFile . '" &'

  execute 'lcd ' . masterDir
  execute 'silent! !' execString
  redraw!
  return ''
endfunction

function! s:Zathura()
  if &ft != 'tex'
    echo "calling Zathura from a non-tex file"
    return ''
  end

  let masterDir = expand("%:p:h")
  let masterTeXFile = s:master
  let masterPDFFile = fnamemodify(masterTeXFile, ":t:r") . '.pdf'
  let viewer = 'zathura -x "vim --servername synctex -n --remote-silent +\%{line} \%{input}"'
  let execString = 'cd ' . masterDir . ' && ' . viewer . ' "' . masterPDFFile . '" &'

  execute 'lcd ' . masterDir
  execute 'silent! !' execString
  redraw!
  return ''
endfunction

function! s:Qpdfview()
  if &ft != 'tex'
    echo "calling Qpdfview from a non-tex file"
    return ''
  end

  let masterDir = expand("%:p:h")
  let currentTeXFile = expand("%:t")
  let masterTeXFile = s:master
  let masterPDFFile = fnamemodify(masterTeXFile, ":t:r") . '.pdf'
  let viewer = 'qpdfview'
  let execString = 'cd ' . masterDir . ' && ' . viewer . ' --unique "' . masterPDFFile . '\#src:' . currentTeXFile . ':' . line(".") . ':0' . '" &'

  execute 'lcd ' . masterDir
  execute 'silent! !' execString
  redraw!
  return ''
endfunction

function! s:AdobeAcrobatReaderDC()
  if &ft != 'tex'
    echo "calling Adobe Reader from a non-tex file"
    return ''
  end

  let masterDir = expand("%:p:h")
  let masterTeXFile = s:master
  let masterPDFFile = fnamemodify(masterTeXFile, ":t:r") . '.pdf'
  if has('win32') || has('win64')
    if glob('C:/Program Files/Adobe/Acrobat Reader DC/Reader/AcroRd32.exe') != ''
      let viewer = '"' . glob('C:/Program Files/Adobe/Acrobat Reader DC/Reader/AcroRd32.exe') . '"'
    elseif glob('C:/Program Files (x86)/Adobe/Adobe Reader DC/Reader/AcroRd32.exe') != ''
      let viewer = '"' . glob('C:/Program Files (x86)/Adobe/Acrobat Reader DC/Reader/AcroRd32.exe') . '"'
    else
      let viewer = 'pdfopen --r15 --file'
    endif
    let execString = 'cd /d ' . masterDir . ' && echo ' . viewer . ' "' . masterPDFFile . '" | cmd'
  elseif has('macunix')
    let viewer = 'open -a "Adobe Acrobat Reader DC.app"'
    let execString = 'cd ' . masterDir . ' && ' . viewer . ' "' . masterPDFFile . '" &'
  else
    let viewer = 'wine ~/.wine/drive_c/Program\ Files*/Adobe/Acrobat\ Reader\ DC/Reader/AcroRd32.exe'
    let execString = 'cd ' . masterDir . ' && ' . viewer . ' "' . masterPDFFile . '" &'
  endif

  execute 'lcd ' . masterDir
  execute 'silent! !' execString
  redraw!
  return ''
endfunction

" Command definitions and Mappings
command! -nargs=1 -buffer Typeset :call <SID>SetTypeset(<f-args>)
command! -nargs=1 -buffer Viewer :call <SID>SetViewer(<f-args>)
command! -nargs=1 -buffer TeXmaster :call <SID>SetTeXmaster(<f-args>)

nnoremap <expr><silent><buffer> <Leader>e <SID>Latexmk('default', 1, 0)
nnoremap <expr><silent><buffer> <Leader>E <SID>Latexmk('default', 0, 1)
nnoremap <expr><silent><buffer> <Leader>x <SID>Latexmk('pdf', 1, 0)
nnoremap <expr><silent><buffer> <Leader>X <SID>Latexmk('pdf', 0, 1)
"nnoremap <expr><silent><buffer> <Leader>e <SID>TypesetFile()
nnoremap <expr><silent><buffer> <Leader>v <SID>ViewFile()
nnoremap <expr><silent><buffer> <Leader>r <SID>SetTeXmasterCurrent()
nnoremap <expr><silent><buffer> <Leader>R <SID>EchoTeXmaster()

