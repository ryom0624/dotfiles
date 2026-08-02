"#####表示設定#####
set title "編集中のファイル名を表示
set number "行番号を表示する
set relativenumber "現在行以外を相対行番号で表示
set cursorline "カーソル行を強調表示
set showmatch "括弧入力時の対応する括弧を表示
syntax enable
set tabstop=4 "インデントをスペース4つ分に設定
set shiftwidth=4 "自動インデントの幅を4文字に設定
set softtabstop=4 "TabやBackspaceを4文字単位で操作
set expandtab "Tab入力をスペースに変換
set smartindent "オートインデント
set undofile "Vim終了後もUndo履歴を保存
set wildmenu "コマンド補完候補を見やすく表示
filetype plugin indent on "ファイル形式ごとの設定とインデントを有効化

"#####検索設定#####
set ignorecase "大文字/小文字の区別なく検索する
set smartcase "検索文字列に大文字が含まれている場合は区別して検索する
set wrapscan "検索時に最後まで行ったら最初に戻る
set incsearch "入力中の検索文字列に一致する箇所を表示
set hlsearch "検索結果を強調表示

"##### color ######
autocmd ColorScheme * highlight LineNr ctermfg=100

set background=dark
"colorscheme molokai
colorscheme hybrid

set mouse=a
