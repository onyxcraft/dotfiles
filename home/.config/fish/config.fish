# Fish Shell Configuration
# Managed via dotfiles

# ===========================================
# PATH Configuration
# ===========================================
fish_add_path $HOME/.local/bin
fish_add_path $HOME/bin
fish_add_path $HOME/go/bin
fish_add_path /opt/homebrew/bin
fish_add_path /opt/homebrew/sbin
fish_add_path (brew --prefix)/opt/fzf/bin 2>/dev/null

# ===========================================
# Homebrew
# ===========================================
set -gx HOMEBREW_PREFIX /opt/homebrew
set -gx HOMEBREW_CELLAR $HOMEBREW_PREFIX/Cellar
set -gx HOMEBREW_REPOSITORY $HOMEBREW_PREFIX

# ===========================================
# Package Managers
# ===========================================
# Rust
set -gx CARGO_HOME $HOME/.cargo
set -gx RUSTUP_HOME $HOME/.rustup

# Go
set -gx GOPATH $HOME/go
set -gx PATH $GOPATH/bin $PATH

# ===========================================
# Development
# ===========================================
# Node
set -gx NODE_PATH (npm root -g)

# Flutter
set -gx ANDROID_HOME $HOME/Library/Android/sdk
set -gx ANDROID_SDK_ROOT $ANDROID_HOME
set -gx FLUTTER_ROOT (brew --prefix)/opt/flutter
set -gx PATH $FLUTTER_ROOT/bin $PATH

# ===========================================
# UI / Terminal
# ===========================================
# Less Colors
set -gx LESS_TERMCAP_mb (printf "\033[1;31m")
set -gx LESS_TERMCAP_md (printf "\033[1;36m")
set -gx LESS_TERMCAP_me (printf "\033[0m")
set -gx LESS_TERMCAP_se (printf "\033[0m")
set -gx LESS_TERMCAP_so (printf "\033[1;44;33m")
set -gx LESS_TERMCAP_ue (printf "\033[0m")
set -gx LESS_TERMCAP_us (printf "\033[1;32m")

# Editor
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx PAGER less

# ===========================================
# Tools Configuration
# ===========================================
# Starship Prompt
starship init fish | source

# Zoxide (cd alternative)
zoxide init fish | source

# Atuin (better history)
atuin init fish | source

# Direnv
direnv hook fish | source

# FZF
if test -d (brew --prefix)/opt/fzf
    fzf_key_bindings
end

# ===========================================
# Aliases
# ===========================================
# Modern tools
alias ls='eza --icons'
alias ll='eza -l --icons'
alias la='eza -la --icons'
alias lt='eza --tree --level=2'

alias cat='bat'
alias top='btop'
alias ps='procs'

# Git
alias g='git'
alias gs='git status'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'
alias gd='git diff'
alias gco='git checkout'

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Development
alias ip='ipython'
alias py='python3'
alias vim='nvim'
alias v='nvim'

# Utilities
alias open='open'
alias ports='lsof -i -P -n | grep LISTEN'
alias myip='curl http://ipecho.net/plain; echo'

# Safety
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# ===========================================
# Functions
# ===========================================
# Create and cd into directory
function mkcd
    mkdir -p $argv[1]; and cd $argv[1]
end

# Extract archives
function extract
    if test -f $argv[1]
        switch $argv[1]
            case '*.tar.bz2'
                tar xjf $argv[1]
            case '*.tar.gz'
                tar xzf $argv[1]
            case '*.bz2'
                bunzip2 $argv[1]
            case '*.rar'
                unrar x $argv[1]
            case '*.gz'
                gunzip $argv[1]
            case '*.tar'
                tar xf $argv[1]
            case '*.tbz2'
                tar xjf $argv[1]
            case '*.tgz'
                tar xzf $argv[1]
            case '*.zip'
                unzip $argv[1]
            case '*.Z'
                uncompress $argv[1]
            case '*.7z'
                7z x $argv[1]
            case '*'
                echo "'$argv[1]' cannot be extracted"
        end
    else
        echo "'$argv[1]' is not a valid file"
    end
end

# Git functions
function gstash
    git stash push -m (date +%Y%m%d%H%M%S)
end

# ===========================================
# Interactive Config
# ===========================================
if status is-interactive
    # Source uv environment if available
    if test -f $HOME/.local/share/uv/uv.fish
        source $HOME/.local/share/uv/uv.fish
    end

    # Load any additional local config
    if test -f $HOME/.config/fish/local.fish
        source $HOME/.config/fish/local.fish
    end
end
