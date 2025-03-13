PATH := /opt/homebrew/bin:${PATH}

.PHONY: all

all: install deploy defaults

install: brew bundle

brew:
	@scripts/install/homebrew.sh;

bundle:
	@scripts/install/brew-bundle.sh;

deploy:
	@scripts/install/deploy.sh;

defaults:
	@scripts/install/defaults.sh;

uninstall:
	@scripts/uninstall/homebrew.sh;

