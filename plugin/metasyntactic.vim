" metasyntactic.vim - VIM interface to Acme::MetaSyntacitc
" Maintainer:   Steven Humphrey
" Version:      0.2
"
" Assuming you have pathogen, install in ~/.vim/bundle/metasyntactic/plugin
" Alternatively, put it somewhere else and manually source it from your vimrc
" file.
"
" Run the following command to get an Acme::MetaSyntactic word
"   :call GetMetaSyntacticWord()
"
" I suggest something like the following key maps in your vimrc
"   map <leader>n "=GetMetaSyntacticWord()<C-M>p
"   imap ,n <C-R>=GetMetaSyntacticWord()<C-M>
"
" They use the default register and your <leader>mapping
" WA
" TODO: fix
"
" To set a different theme:
"   :call SetMetaSyntacticTheme('batman')
" To list available themes:
"   :call ListMetaSyntacticThemes()
"
" These scripts require vim to be built with perl.
" These scripts also require Acme::MetaSyntactic to be installed in the
" *right* perl
" Trying running
"   :perl print join("\n", @INC), "\n"
" To see what perl you are running
"

" Private function to initialise the MetaSyntactic instance.
fun! s:initMetaSyntactic()
    if has('perl')
        function! s:defPerlMetaSynInit()
            perl <<EOF
                eval {
                    require Acme::MetaSyntactic;
                    Acme::MetaSyntactic->import;
                };
                if ( $@ ) {
                    # die "Acme::MetaSyntactic is not installed in system perl\n";
                    VIM::Msg("Acme::MetaSyntactic is not installed in system perl","ErrorMsg");
                }
                else {
                    our $meta = Acme::MetaSyntactic->new($theme);
                }
EOF
        endfunction
        call s:defPerlMetaSynInit()
    endif
endfun

" Returns a word
fun! GetMetaSyntacticWord()
    if has('perl')
        function! s:defPerlMetaSynGetWord()
            perl <<EOF
            our $meta;
            if ( !defined $meta ) { VIM::DoCommand("call s:initMetaSyntactic()"); }

            my $word = 'Acme::MetaSyntactic is not installed in vims perl';
            if ( defined $meta ) {
                my ($row, $col) = $curwin->Cursor;
                $word = $meta->name;

                # Is there a better way to do this?
                VIM::DoCommand("let metaword='$word'");
            }
EOF
            if exists("metaword")
                return metaword
            endif
            return ''
        endfunction
        return s:defPerlMetaSynGetWord()
    else
        echohl ErrorMsg | echo "metasyntactic.vim requires vim compiled with perl. See :version" | echohl None;
        return ''
    endif
endfun


" Sets the theme
fun! SetMetaSyntacticTheme(theme)
    if has('perl')
        function! s:defPerlMetaSynTheme(theme)
        perl <<EOF
            my $theme = VIM::Eval('a:theme');
            our $meta;
            if ( !defined $meta ) { VIM::DoCommand("call s:initMetaSyntactic()"); }

            if ( !$meta->has_theme($theme) ) {
                VIM::Msg("theme $theme is not installed", "ErrorMsg");
                return;
            }
            VIM::Msg("Theme is " . $theme);
EOF
        endfunction
        call s:defPerlMetaSynTheme(a:theme)
    endif
endfun

" Lists all available themes
fun! ListMetaSyntacticThemes()
    if has('perl')
        function s:defPerlMetaSynList()
            perl <<EOF
                our $meta;
                if ( !defined $meta ) { VIM::DoCommand("call s:initMetaSyntactic()"); }
                my @themes = $meta->themes;
                VIM::Msg(join("\n", @themes));
EOF
        endfunction
        call s:defPerlMetaSynList()
    endif
endfun
