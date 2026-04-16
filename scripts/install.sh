#!/usr/bin/env bash
#
# dotfiles Installation Script
# Managed via stow + GNU Stow
#
# Usage:
#   ./install.sh              # Interactive installation
#   ./install.sh --all       # Install everything
#   ./install.sh --home       # Install home directory configs only
#   ./install.sh --brew       # Install Homebrew packages only
#   ./install.sh --sync       # Sync existing configs to dotfiles

set -e

DOTFILES_DIR="$HOME/dotfiles"
BACKUP_DIR="$HOME/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Backup existing config
backup_config() {
    local config=$1
    if [ -e "$HOME/$config" ] || [ -L "$HOME/$config" ]; then
        log_warn "Backing up existing $config"
        mkdir -p "$BACKUP_DIR"
        mv "$HOME/$config" "$BACKUP_DIR/"
    fi
}

# Create symlink
create_link() {
    local source=$1
    local target=$2
    local dir=$(dirname "$target")

    if [ ! -d "$dir" ]; then
        mkdir -p "$dir"
    fi

    if [ -e "$target" ] || [ -L "$target" ]; then
        if [ ! -L "$target" ] || [ "$(readlink -f "$target")" != "$(readlink -f "$source")" ]; then
            log_warn "Removing existing $target"
            rm -rf "$target"
            ln -s "$source" "$target"
            log_success "Linked $target -> $source"
        else
            log_info "Already linked: $target"
        fi
    else
        ln -s "$source" "$target"
        log_success "Linked $target -> $source"
    fi
}

# Install via stow
stow_configs() {
    log_info "Installing configurations via GNU Stow..."
    cd "$DOTFILES_DIR/home"

    # Stow all packages
    for pkg in .??* */; do
        if [ -d "$pkg" ] && [ "$pkg" != ".git" ]; then
            stow -v -t "$HOME" "$pkg" 2>/dev/null || log_warn "Failed to stow $pkg"
        fi
    done

    log_success "Stow installation complete!"
}

# Install Homebrew
install_homebrew() {
    log_info "Installing Homebrew..."
    if ! command -v brew &> /dev/null; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    log_success "Homebrew installed!"
}

# Install packages from Brewfile
install_brew_packages() {
    log_info "Installing packages from Brewfile..."
    cd "$DOTFILES_DIR/Brewfile"

    if [ -f "Brewfile" ]; then
        brew bundle install --verbose
        log_success "Brewfile packages installed!"
    else
        log_error "Brewfile not found!"
    fi
}

# Install Fish Shell
install_fish() {
    log_info "Setting up Fish Shell..."

    # Backup existing config
    if [ -f "$HOME/.config/fish/config.fish" ]; then
        backup_config ".config/fish/config.fish"
    fi

    # Set Fish as default shell
    if command -v fish &> /dev/null; then
        if ! grep -q "fish" /etc/shells; then
            echo "/opt/homebrew/bin/fish" | sudo tee -a /etc/shells
        fi
        chsh -s /opt/homebrew/bin/fish
        log_success "Fish shell set as default!"
    fi
}

# Install Neovim plugins
install_neovim_plugins() {
    log_info "Installing Neovim plugins..."
    if command -v nvim &> /dev/null; then
        nvim --headless +PlugInstall +qall 2>/dev/null || \
        nvim --headless +Lazy\ sync +qall 2>/dev/null || \
        log_warn "Please run :Lazy sync in Neovim to install plugins"
    fi
}

# Install macOS defaults
install_macos_defaults() {
    log_info "Installing macOS defaults..."

    # Ask before applying
    read -p "Apply macOS defaults? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        return
    fi

    # Trackpad
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
    defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

    # Finder
    defaults write com.apple.finder ShowPathBar -bool true
    defaults write NSGlobalDomain AppleShowAllExtensions -bool true

    # Dock
    defaults write com.apple.dock autohide -bool true
    defaults write com.apple.dock showhidden -bool true

    # Speed up key repeat
    defaults write NSGlobalDomain KeyRepeat -int 1
    defaults write NSGlobalDomain InitialKeyRepeat -int 10

    killall Dock
    log_success "macOS defaults applied!"
}

# Main installation
install_all() {
    log_info "Starting full installation..."

    install_homebrew
    install_brew_packages
    stow_configs
    install_fish
    install_neovim_plugins

    log_success "Installation complete!"
    log_info "Please restart your terminal or run: exec $SHELL"
}

# Sync existing configs to dotfiles
sync_to_dotfiles() {
    log_info "Syncing current configs to dotfiles..."
    log_warn "This feature is not yet implemented"
    log_info "Please manually copy configs to $DOTFILES_DIR/home/"
}

# Show usage
usage() {
    echo "dotfiles Installation Script"
    echo ""
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --all       Install everything"
    echo "  --home      Install home directory configs only"
    echo "  --brew      Install Homebrew packages only"
    echo "  --fish      Install and configure Fish shell"
    echo "  --nvim      Install Neovim plugins"
    echo "  --macos     Apply macOS defaults"
    echo "  --sync      Sync existing configs to dotfiles"
    echo "  --help      Show this help message"
    echo ""
}

# Main
main() {
    cd "$DOTFILES_DIR"

    case "${1:-}" in
        --all)
            install_all
            ;;
        --home)
            stow_configs
            ;;
        --brew)
            install_homebrew
            install_brew_packages
            ;;
        --fish)
            install_fish
            ;;
        --nvim)
            install_neovim_plugins
            ;;
        --macos)
            install_macos_defaults
            ;;
        --sync)
            sync_to_dotfiles
            ;;
        --help|*)
            usage
            ;;
    esac
}

main "$@"
