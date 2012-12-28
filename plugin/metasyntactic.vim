" metasyntactic.vim - VIM interface to Acme::MetaSyntacitc
" Maintainer:   Steven Humphrey
" Version:      0.1
"
" Assuming you have pathogen, install in ~/.vim/bundle/metasyntactic/plugin
" Alternatively, put it somewhere else and manually source it from your vimrc
" file.
"
" I suggest something like the following key maps in your vimrc
"   imap <leader>n <C-R>=GetMetaSyntacticWord()<C-M>
"   map <leader>n "=GetMetaSyntacticWord()<C-M>p
" They use the default register and your <leader>mapping
"
" To set a different theme:
"   :call SetMetaSyntacticTheme('batman')
" To list available themes:
"   :call ListMetaSyntacticThemes()
"
" These scripts require vim to be built with perl.

" Private function to initialise the MetaSyntactic instance.
fun! s:initMetaSyntactic()
perl <<EOF
    eval {
        require Acme::MetaSyntactic;
        Acme::MetaSyntactic->import;
    };
    if ( $@ ) {
        VIM::Msg("Acme::MetaSyntactic is not installed in system perl", "ErrorMsg");
        return;
    }
    our $meta = Acme::MetaSyntactic->new($theme);
EOF
endfun

" Returns a word
fun! GetMetaSyntacticWord()
perl <<EOF
    our $meta;
    if ( !defined $meta ) { VIM::DoCommand("call s:initMetaSyntactic()"); }
    my ($row, $col) = $curwin->Cursor;
    my $word = $meta->name;

    # Is there a better way to do this?
    VIM::DoCommand("let metaword='$word'");
EOF
    return metaword
endfun

" Inserts the word at current cursor position
fun! InsertMetaSyntacticWord()
    let metaword = GetMetaSyntacticWord()
    echo metaword
endfun

" Sets the theme
fun! SetMetaSyntacticTheme(theme)
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
endfun

" Lists all available themes
fun! ListMetaSyntacticThemes()
perl <<EOF
    our $meta;
    if ( !defined $meta ) { VIM::DoCommand("call s:initMetaSyntactic()"); }
    my @themes = $meta->themes;
    VIM::Msg(join("\n", @themes));
EOF
endfun
