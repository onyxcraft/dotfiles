# dotfiles

My personal dotfiles managed via GNU Stow.

## Structure

```
dotfiles/
├── home/           # Home directory configs (~)
│   ├── .config/   # App configs
│   ├── .zshrc     # Zsh configuration
│   ├── .gitconfig # Git configuration
│   └── ...
├── Brewfile/      # Homebrew packages
└── scripts/       # Installation scripts
```

## Quick Install

```bash
# Clone this repo
git clone https://github.com/onyx-light/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Install everything
./scripts/install.sh --all

# Or install specific parts
./scripts/install.sh --brew    # Homebrew packages
./scripts/install.sh --home   # Dotfiles only
./scripts/install.sh --fish    # Fish shell
```

## Manual Install

```bash
# Navigate to dotfiles
cd ~/dotfiles/home

# Stow all configs
stow -t ~ */

# Or stow specific package
stow -t ~ .config
```

## Adding New Config

```bash
# Copy your config to dotfiles
cp ~/.config/your-app/config.toml ~/dotfiles/home/.config/your-app/

# Stow it
cd ~/dotfiles/home
stow -t ~ .config/your-app
```

## Updating Brewfile

```bash
brew bundle dump --file=~/dotfiles/Brewfile/Brewfile --describe
```

## Included Configs

- **Shell**: zsh, fish, bash
- **Terminal**: tmux, wezterm, ghostty
- **Editor**: neovim, zed
- **Git**: gh CLI, lazygit
- **macOS**: karabiner, hammerspoon, sketchybar, yabai, skhd
- **Tools**: starship, fzf, zoxide, atuin, direnv
- **Development**: go, rust, node, flutter, uv
- **Media**: mpd, cava, spicetify
- **System**: btop, htop

## Requirements

- macOS (tested on macOS 13+)
- Homebrew
- GNU Stow
- Git
