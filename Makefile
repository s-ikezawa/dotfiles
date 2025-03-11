all: install

install: brew bundle

brew:
	@scripts/install/homebrew.sh

bundle:
	@scripts/install/brew-bundle.sh

uninstall:
	@scripts/uninstall/homebrew.sh

.PHONY: all
