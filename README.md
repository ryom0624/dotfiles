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
6. `_safe_link` 関数で以下の設定を安全にリンク（既存の通常ファイルは `.bak.YYYYMMDDHHMMSS` へバックアップ、再実行は冪等）
   - `~/.config/herdr/config.toml` → `config/herdr/config.toml`
   - `~/.gitconfig` → `config/git/config`
   - `~/Library/Application Support/Cursor/User/settings.json` → `config/cursor/settings.json`
   - `~/Library/Application Support/Cursor/User/keybindings.json` → `config/cursor/keybindings.json`
   - `~/.config/karabiner/karabiner.json` → `config/karabiner/karabiner.json`

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
├── agents/
│   ├── CLAUDE.md        # Claude グローバル指示
│   ├── AGENTS.md        # Codex グローバル指示
│   └── claude/          # CLAUDE.md が依存するファイルの控え
│       ├── scripts/     # codex-wrapper 系
│       └── templates/   # プロジェクト初期化用テンプレート
├── config/
│   ├── cursor/
│   │   ├── settings.json    # Cursor エディタ設定（JSONC）
│   │   └── keybindings.json # Cursor キーバインド
│   ├── git/
│   │   └── config           # Git グローバル設定（~/.gitconfig へリンク）
│   ├── herdr/
│   │   └── config.toml      # Herdr 設定（~/.config/herdr/config.toml へリンク）
│   └── karabiner/
│       └── karabiner.json   # Karabiner-Elements 設定
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

## 管理対象ファイル一覧

| dotfiles 内パス | リンク先 | 備考 |
|----------------|---------|------|
| `.zshrc` | `~/.zshrc` | zsh メイン設定 |
| `.zprofile` | `~/.zprofile` | ログインシェル設定 |
| `.vimrc` | `~/.vimrc` | Vim 設定 |
| `.vim/` | `~/.vim/` | Vim ディレクトリ |
| `.tmux.conf` | `~/.tmux.conf` | tmux 設定 |
| `config/git/config` | `~/.gitconfig` | Git グローバル設定 |
| `config/cursor/settings.json` | `~/Library/Application Support/Cursor/User/settings.json` | JSONC 形式 |
| `config/cursor/keybindings.json` | `~/Library/Application Support/Cursor/User/keybindings.json` | Cursor キーバインド |
| `config/karabiner/karabiner.json` | `~/.config/karabiner/karabiner.json` | Karabiner-Elements 設定 |
| `config/herdr/config.toml` | `~/.config/herdr/config.toml` | Herdr 設定 |
| `agents/CLAUDE.md` | `~/.claude/CLAUDE.md` | Claude グローバル指示（手動リンク） |
| `agents/AGENTS.md` | `~/.codex/AGENTS.md` | Codex グローバル指示（手動リンク） |
| `agents/claude/scripts/` | （リンクなし） | `~/.claude/scripts/` の控え |
| `agents/claude/templates/` | （リンクなし） | `~/.claude/templates/` の控え |

---

## AI エージェント設定の方針

### 管理範囲

`agents/` にはグローバル指示のみを置きます。

| 対象 | 管理 | 理由 |
|------|------|------|
| グローバル指示（`CLAUDE.md` / `AGENTS.md`） | dotfiles（リンク） | 秘密情報を含まず、環境間で共通 |
| 指示が依存するスクリプト・テンプレート | dotfiles（控え） | 指示だけあっても動かないため、内容を追跡できるようにする |
| skills | 管理外 | 業務・取引関連など公開したくないものが混ざる |
| hooks | 管理外 | 環境ごとに有効・無効を変えるため |
| `settings.json` / `config.toml` | 管理外 | Codex の `config.toml` は承認済みディレクトリを持つ。Claude の `settings.json` は移植可能だが、プラグインの有効・無効を環境ごとに変えるため揃える対象にしない |
| 認証情報・履歴・ログ | 管理外 | `auth.json`、`history.jsonl`、`sessions/` は公開リポジトリに置かない |

### 依存ファイルの扱い

`CLAUDE.md` は `~/.claude/` 配下の実ファイルを参照します。指示だけを管理しても再現できないので、依存先を `agents/claude/` に控えとして置いています。

| dotfiles の控え | 実体 | 参照元 |
|----------------|------|--------|
| `agents/claude/scripts/codex-wrapper.sh` | `~/.claude/scripts/codex-wrapper.sh` | 実装・レビューの委譲 |
| `agents/claude/scripts/codex-wrapper-readonly.sh` | 同 `scripts/` | 読み取り専用実行 |
| `agents/claude/scripts/codex-wrapper-test-failure-stub.sh` | 同 `scripts/` | テスト用スタブ |
| `agents/claude/templates/` | `~/.claude/templates/` | プロジェクト初期化 |

**控えはシンボリックリンクではありません。** `~/.claude/` 側が動作する実体で、dotfiles 側は記録用のコピーです。実体を変更したら手動でコピーし直してください。自動同期はしていないので、差分は次のコマンドで確認できます。

```sh
diff -r ~/.claude/scripts/codex-wrapper.sh ~/dotfiles/agents/claude/scripts/codex-wrapper.sh
diff -r ~/.claude/templates ~/dotfiles/agents/claude/templates
```

`CLAUDE.md` が参照する `skills/codex-coding/SKILL.md` は控えを置いていません。skills 全体を管理外としているためで、新しい環境では別途用意する必要があります。

### ファイル構成の方針

各ファイルは自己完結させます。共通ファイルへの切り出しや import は行いません。エージェントごとに読み込まれる指示がファイル単体で完結していれば、挙動を追いやすく、片方だけ調整することもできます。

- `CLAUDE.md` — 共通の基本方針に加えて、ワークフロー、Codex CLI への委譲手順、エージェントチーム構成。
- `AGENTS.md` — 共通の基本方針に加えて、回答の構成、曖昧さへの対応、投資分析の観点。

両者で重なる方針（言語、事実と推測の区別、批判的検討、最小差分、秘密情報、Python 実行環境、コーディング規約）は、それぞれのファイルに書きます。方針を変えるときは両方を確認してください。

### 適用方法

グローバル指示だけをリンクします。`setup.sh` では自動化していません（`~/.claude/` に管理外の実体が同居しているため）。

```sh
ln -sf ~/dotfiles/agents/CLAUDE.md ~/.claude/CLAUDE.md
ln -sf ~/dotfiles/agents/AGENTS.md ~/.codex/AGENTS.md
```

`agents/claude/` の控えはリンクしません。上記の `diff` で差分を見て、必要なときに手でコピーします。

### 書き方のルール

- 検証可能で行動につながる指示だけを書く。「ベストプラクティスに従う」のような曖昧な文は書かない。
- 「例外なし」と書いた規則には例外を作らない。守れない条件があるなら、その条件を規則に書く。
- モデル名、言語バージョン、ツールのバージョンを埋め込まない。バージョンはプロジェクト側の `pyproject.toml` やロックファイルを正とする。
- 言語ごとのコーディング規約はグローバル指示に書かず、`coding-standards` skill に置く。
- 管理外のパスを参照する指示には、存在しない場合の代替手順を添える。
- 特定のターミナル環境（tmux など）に依存する手順を書かない。

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
