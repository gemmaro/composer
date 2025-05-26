translate:
	po4a po4a.cfg
	./remove-untranslated-changelog ${CURDIR}/ja/CHANGELOG.md
.PHONY: translate

deploy: build
	rsync -av ../book/ pi:/srv/www/composer/
.PHONY: deploy

build: tmp/mdbook translate
	cd .. && translations/tmp/mdbook build
.PHONY: build

tmp/mdbook: tmp/mdbook-v0.4.51-x86_64-unknown-linux-gnu.tar.gz
	cd tmp && tar xvf $(notdir $(wildcard tmp/mdbook-*.tar.gz))

tmp/mdbook-v0.4.51-x86_64-unknown-linux-gnu.tar.gz:
	mkdir -p tmp
	cd tmp && wget https://github.com/rust-lang/mdBook/releases/download/v0.4.51/mdbook-v0.4.51-x86_64-unknown-linux-gnu.tar.gz
