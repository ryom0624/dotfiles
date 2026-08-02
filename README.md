# dotfiles

macOS 向けの個人設定ファイル一式です。zsh の基本設定・履歴・プロンプト・エイリアスと、fzf を中心としたプラグインを管理します。`setup.sh` を実行するだけでシンボリックリンクの作成とプラグインのインストールが完了します。

---

## 前提条件

| 項目 | 備考 |
|------|------|
| macOS | Apple Silicon・Intel どちらも対応 |
| zsh | macOS 標準搭載 |
| git | サブモジュール取得に必要 |
| Homebrew | プラグイン導入には不要。ただし `.zprofile` は既存の Homebrew がある場合に `shellenv` を自動初期化します |

---

## セットアップ

### サブモジュールを含めてクローン

```sh
git clone --recurse-submodules git@github.com:ryom0624/dotfiles.git ~/dotfiles
cd ~/dotfiles
./setup.sh
```

### すでにクローン済みの場合

```sh
cd ~/dotfiles
git submodule update --init --recursive
./setup.sh
```

`setup.sh` は以下を行います。

1. スクリプト自身の実体ディレクトリを解決（シンボリックリンク越しでも正常動作、macOS Bash 3.2 対応）
2. `git submodule update --init --recursive` でサブモジュールを初期化・更新
3. `tools/fzf/install --bin` で fzf バイナリをインストール
4. `~/.local/bin/fzf` → `tools/fzf/bin/fzf` のシンボリックリンクを作成
5. `.zshrc` `.zprofile` `.vim` `.vimrc` `.tmux.conf` を `$HOME` へシンボリックリンク
6. `~/.config/herdr/config.toml` → `config/herdr/config.toml` のシンボリックリンクを作成（既存の通常ファイルは `.bak.YYYYMMDDHHMMSS` へバックアップ、再実行は冪等）

---

## ディレクトリ構成

```
dotfiles/
├── setup.sh             # セットアップスクリプト
├── .zshrc               # zsh メイン設定
├── .zprofile            # ログインシェル設定（PATH・Homebrew）
├── .vimrc               # Vim 設定
├── .vim/                # Vim ディレクトリ
├── .tmux.conf           # tmux 設定
├── config/
│   └── herdr/
│       └── config.toml  # Herdr 設定（~/.config/herdr/config.toml へリンク）
├── zsh/
│   ├── plugins.zsh      # プラグイン読み込み設定
│   └── plugins/
│       ├── fzf-tab/                  # サブモジュール
│       ├── zsh-autosuggestions/      # サブモジュール
│       └── zsh-syntax-highlighting/  # サブモジュール
└── tools/
    └── fzf/             # fzf 本体（サブモジュール）
```

---

## 基本設定

| 設定 / オプション | 内容 |
|------------------|------|
| `LANG` | `ja_JP.UTF-8` |
| `compinit` | 補完機能を有効化 |
| `AUTO_CD` | `cd` を省略してディレクトリ名だけで移動 |
| `AUTO_PUSHD` | `cd` の履歴を自動でディレクトリスタックに積む |
| `PUSHD_IGNORE_DUPS` | スタックの重複エントリを排除 |
| `colors` | ターミナルカラーを有効化 |
| `print_eight_bit` | 日本語ファイル名を正しく表示 |
| `no_beep` | ビープ音を無効化 |
| `nolistbeep` | 補完時のビープ音を無効化 |
| 補完 matcher | 小文字入力で大文字にもマッチ（`m:{a-z}={A-Z}`） |
| sudo 補完 | `sudo` の後ろでコマンド名を補完 |
| `ignore_eof` | `Ctrl+D` でシェルを終了しない |
| `correct` | コマンドのスペルを自動修正候補表示 |
| `auto_list` | 補完候補を一覧表示 |
| `auto_menu` | Tab で補完候補を順に切り替え |
| 補完メニュー | 通常は Tab・矢印キーで選択。fzf-tab 読み込み時は fzf UI に切り替え |
| `LS_COLORS` / `LSCOLORS` | `ls` の色設定 |
| 補完候補の色 | `LS_COLORS` に基づいてファイル補完候補を着色 |
| `LESS` | `-R`（ANSIカラーシーケンスを有効化） |
| vcs_info | Git ブランチ名をプロンプトに表示 |
| 左プロンプト | カレントディレクトリ＋ Git ブランチ |
| 右プロンプト | 終了コード（失敗時のみ表示）＋現在時刻 |

---

## 履歴設定

| 設定 / オプション | 内容 |
|------------------|------|
| `HISTFILE` | `~/.z_history` |
| `HISTSIZE` | `1000000`（メモリ上の保持件数） |
| `SAVEHIST` | `1000000`（ファイルへの保存件数） |
| `extended_history` | 実行日時・経過時間も記録 |
| `share_history` | 複数ターミナル間で履歴を共有 |
| `hist_ignore_all_dups` | 重複する古い履歴を削除 |
| `hist_ignore_space` | コマンド先頭がスペースの場合は記録しない |
| `hist_verify` | ヒストリ展開後に実行前編集が可能 |
| `hist_reduce_blanks` | 余分なスペースを除去して記録 |
| `hist_save_no_dups` | 重複エントリをファイルに保存しない |
| `hist_expire_dups_first` | 上限超過時に重複履歴から優先削除 |
| `hist_expand` | 補完時にヒストリを自動展開 |
| `inc_append_history` | **無効**（コメントアウト） |

---

## プラグイン

Git サブモジュールで管理され、`zsh/plugins.zsh` により compinit 後に順番どおりロードされます。

| プラグイン | 役割 |
|-----------|------|
| [fzf-tab](https://github.com/Aloxaf/fzf-tab) | zsh 補完候補を fzf の UI で選択 |
| [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) | 履歴をもとにコマンドの続きをグレーでサジェスト |
| [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting) | 既知コマンドを緑、未知トークンを赤でハイライト |
| [fzf](https://github.com/junegunn/fzf) | 高速ファジーファインダー本体（`~/.local/bin/fzf` にリンク） |

> **ロード順:** fzf-tab → zsh-autosuggestions → zsh-syntax-highlighting

---

## 主なエイリアス

| エイリアス | コマンド | 用途 |
|-----------|---------|------|
| `rmi` | `rm -i` | 削除時に確認を求める |
| `ls` | `ls -FG` | ファイル種別記号・カラー表示 |
| `la` | `ls -lahFG` | 隠しファイルを含む詳細一覧 |
| `ll` | `ls -lhFG` | 詳細一覧 |
| `..` | `cd ..` | 親ディレクトリへ移動 |
| `hosts` | `sudo vi /etc/hosts` | hosts ファイルを編集 |
| `reload` | `source ~/.zshrc` | zsh 設定を再読み込み |
| `zshrc` | `${EDITOR:-vi} ~/.zshrc` | `.zshrc` をエディタで開く |
| `gs` | `git status` | |
| `ga` | `git add` | |
| `gc` | `git commit` | |
| `gp` | `git push` | |
| `gl` | `git pull` | |
| `gclone` | `git clone` | |
| `h` | `herdr` | herdr のショートカット |

---

## Herdr 設定

`config/herdr/config.toml` で管理する最小構成です。`setup.sh` が `~/.config/herdr/config.toml` へシンボリックリンクを作成します。

| 設定 | 値 | 内容 |
|------|----|------|
| `[ui] agent_panel_sort` | `"priority"` | エージェントパネルを注意待ち順で表示 |
| `[experimental] pane_history` | `false` | サーバー再起動後のペイン履歴を保持しない |


---

## 更新と反映

### dotfiles を最新に更新

```sh
git pull
git submodule update --init --recursive
```

### 設定を現在のシェルに反映

```sh
reload
```
