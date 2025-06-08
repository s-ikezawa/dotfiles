# ~/.config/zsh/.zprofile
# Zsh profile file for login shells - executed before .zshrc

# Homebrew setup for Apple Silicon Mac
if [[ -f "/opt/homebrew/bin/brew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi
