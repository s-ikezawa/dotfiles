xcode-select --install
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply s-ikezawa
git remote set-url origin git@github.com:s-ikezawa/dotfiles.git

