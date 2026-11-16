#!/usr/bin/env bash
# Bootstrap this dev environment on a fresh macOS machine.
#   curl -fsSL https://raw.githubusercontent.com/nathanjones-ts/dotfiles/main/install.sh | bash
# Safe to re-run.
set -euo pipefail

REPO="${DOTFILES_REPO:-https://github.com/nathanjones-ts/dotfiles.git}"
DOTFILES="$HOME/dotfiles"

say() { printf '\n\033[1;34m==> %s\033[0m\n' "$*"; }

# 1. Xcode command line tools (git, compilers)
if ! xcode-select -p >/dev/null 2>&1; then
  say "Installing Xcode Command Line Tools (finish the dialog, then re-run this script)"
  xcode-select --install
  exit 0
fi

# 2. Homebrew
if ! command -v brew >/dev/null 2>&1; then
  say "Installing Homebrew"
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
if [ -x /opt/homebrew/bin/brew ]; then eval "$(/opt/homebrew/bin/brew shellenv)"; else eval "$(/usr/local/bin/brew shellenv)"; fi

# 3. Clone the repo
if [ ! -d "$DOTFILES/.git" ]; then
  say "Cloning dotfiles into $DOTFILES"
  git clone "$REPO" "$DOTFILES"
fi

# 4. Packages
say "Installing Homebrew packages"
brew bundle --file="$DOTFILES/Brewfile"

# 5. Machine-local files that are sourced but never committed
touch "$HOME/.zshrc.local" "$HOME/.gitconfig.local"
chmod 600 "$HOME/.zshrc.local"
if ! git config --file "$HOME/.gitconfig.local" user.email >/dev/null; then
  say "Git identity (stored in ~/.gitconfig.local)"
  read -rp "  Full name: " name </dev/tty
  read -rp "  Email: " email </dev/tty
  git config --file "$HOME/.gitconfig.local" user.name "$name"
  git config --file "$HOME/.gitconfig.local" user.email "$email"
fi

# 6. Symlink dotfiles (also runs hooks/post-up -> installs vim plugins)
say "Linking dotfiles with rcm"
env RCRC="$DOTFILES/rcrc" rcup -f

# 7. Language runtimes via asdf (versions in ~/.tool-versions)
say "Installing asdf plugins and runtimes"
asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git    || true
asdf plugin add ruby   https://github.com/asdf-vm/asdf-ruby.git      || true
asdf plugin add rust   https://github.com/code-lever/asdf-rust.git   || true
asdf plugin add uv     https://github.com/asdf-community/asdf-uv.git || true
(cd "$HOME" && asdf install)

# 8. Neovim plugins (lazy.nvim, pinned by lazy-lock.json)
say "Installing Neovim plugins"
nvim --headless "+Lazy! restore" +qa

# 9. Default shell -> Homebrew zsh
ZSH_PATH="$(brew --prefix)/bin/zsh"
if [ "$SHELL" != "$ZSH_PATH" ]; then
  say "Setting default shell to $ZSH_PATH"
  grep -qx "$ZSH_PATH" /etc/shells || echo "$ZSH_PATH" | sudo tee -a /etc/shells >/dev/null
  chsh -s "$ZSH_PATH"
fi

say "Done. Put secrets/tokens in ~/.zshrc.local, then open a new terminal."
