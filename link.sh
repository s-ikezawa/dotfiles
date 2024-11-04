XDG_CONFIG_HOME=$HOME/.config
REPO_DIR=$HOME/Projects/github.com/s-ikezawa/dotfiles

# zsh
ln -snfv $REPO_DIR/zsh $XDG_CONFIG_HOME/zsh

# vscode
ln -snfv $REPO_DIR/vscode/settings.json $HOME/Library/Application\ Support/Code/User/settings.json
ln -snfv $REPO_DIR/vscode/snippets $HOME/Library/Application\ Support/Code/User/snippets
ln -snfv $REPO_DIR/vscode/keybindings.json $HOME/Library/Application\ Support/Code/User/keybindings.json
