"#####表示設定#####
set title "編集中のファイル名を表示
set number "行番号を表示する
set showmatch "括弧入力時の対応する括弧を表示
syntax enable
set tabstop=4 "インデントをスペース4つ分に設定
set smartindent "オートインデント

"#####検索設定#####
set ignorecase "大文字/小文字の区別なく検索する
set smartcase "検索文字列に大文字が含まれている場合は区別して検索する
set wrapscan "検索時に最後まで行ったら最初に戻る

"##### color ######
autocmd ColorScheme * highlight LineNr ctermfg=100

set background=dark
"colorscheme molokai
colorscheme hybrid

set mouse=a
set ttymouse=xterm2
