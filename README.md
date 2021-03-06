Vim-Acme-MetaSyntactic
======================

Vim interface to Acme::MetaSyntactic

Installation
------------

### With Pathogen

``` 
cd .vim
git clone git://github.com/shumphrey/Vim-Acme-MetaSyntactic.git bundle/metasyntactic
```

Or with git submodules

```
cd .vim
git submodule add git://github.com/shumphrey/Vim-Acme-MetaSyntactic.git bundle/metasyntactic
```

### Without Pathogen

Checkout the module somewhere.
Then inside the .vimrc file, 
```
source metasyntactic.vim
```

Set Up
------

metasyntactic.vim requires key bindings in your .vimrc to work.
Something along the lines of:

```
imap <Leader>n <C-R>=GetMetaSyntacticWord()<C-M>
map <Leader>n "=GetMetaSyntacticWord()<C-M>p
```

(See :help Leader)

Vim & Perl
----------

the metasyntactic plugin requires a vim compiled with the perl option.
You should see a +perl from the following command:

```
vim --version |grep perl
```

Additionally, Acme::MetaSyntactic must be installed in the perl that vim uses.
This is typically the system perl and not any local perl/perlbrew set up.

