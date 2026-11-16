# dotfiles

My macOS dev environment: zsh, tmux, Vim, Neovim, git, and the tools behind them.
Built on [thoughtbot/dotfiles](https://github.com/thoughtbot/dotfiles) and managed with [rcm](https://github.com/thoughtbot/rcm).

## Install on a new machine

```sh
curl -fsSL https://raw.githubusercontent.com/nathanjones-ts/dotfiles/main/install.sh | bash
```

`install.sh` is safe to re-run. It:

1. Installs the Xcode Command Line Tools and Homebrew if they're missing
2. Clones this repo to `~/dotfiles`
3. Installs everything in the `Brewfile`
4. Asks for your git name and email and saves them to `~/.gitconfig.local`
5. Symlinks the dotfiles into `~` with `rcup`, which also installs Vim plugins through vim-plug
6. Installs Ruby, Node, Rust and uv through asdf, at the versions in `tool-versions`
7. Installs the Neovim plugins through lazy.nvim, at the commits in `lazy-lock.json`
8. Points Claude Code's status line at `~/.claude/statusline.sh`. It leaves the rest of `settings.json` alone.
9. Makes Homebrew's zsh your login shell

## What's here

| Path | Linked to | Contents |
| --- | --- | --- |
| `zshrc`, `zshenv`, `zprofile`, `zsh/` | `~/.zshrc` … | Shell config, functions, completions |
| `aliases` | `~/.aliases` | Shell aliases |
| `tmux.conf` | `~/.tmux.conf` | `C-s` second prefix, `\|`/`-` splits, `C-h/j/k/l` moves between panes and Neovim splits |
| `vimrc`, `vimrc.bundles`, `vim/` | `~/.vimrc` … | Vim config and its vim-plug plugin list |
| `config/nvim/` | `~/.config/nvim` | Neovim config using lazy.nvim, with onedark, telescope and vim-tmux-navigator |
| `gitconfig`, `gitignore`, `gitmessage`, `git_template/` | `~/.git*` | Git aliases and defaults |
| `bin/` | `~/.bin` | Git helpers, `tat` (tmux attach), port tools |
| `claude/statusline.sh` | `~/.claude/statusline.sh` | Claude Code status line: the model name and a color-coded bar showing how full the context is |
| `tool-versions` | `~/.tool-versions` | Global asdf runtime versions |
| `Brewfile` | — | Homebrew formulae and casks |

## Secrets and machine-specific settings

These files are sourced if they exist. They are never committed.

- `~/.zshrc.local`: API tokens and env vars, such as `export JIRA_API_TOKEN=…`
- `~/.gitconfig.local`: `[user]` name and email
- `~/.tmux.conf.local`, `~/.vimrc.local`, `~/.vimrc.bundles.local`, `~/.aliases.local`

## Day to day

- **Sync another machine:** `cd ~/dotfiles && git pull && rcup && brew bundle`
- **New dotfile:** `mkrc ~/.somerc` moves it into `~/dotfiles` and symlinks it back.
- **New brew package:** add it to `Brewfile`, or run `brew bundle dump --force --no-cargo --no-uv --no-vscode` from `~/dotfiles`.
- **Neovim plugins:** `:Lazy update` rewrites `config/nvim/lazy-lock.json`. Commit that file.
- **Upstream changes:** `git fetch upstream && git merge upstream/main`
