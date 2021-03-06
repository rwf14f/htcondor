BUNDLE_DIR ?= .bundle
build:
	pdk build

changelog:
	@echo "Updating CHANGELOG.md"
	@github_changelog_generator -u hep-puppet -p htcondor -t ${CHANGELOG_GITHUB_TOKEN}

update_release:
	@python update_release.py
	@echo "Check everything and if OK, execute"
	@echo "git add -u"
	@echo "git commit -m 'tagged version ${RELEASE}'"
	@echo "git push upstream master"
	@echo "git tag v${RELEASE}"
	@echo "git push upstream v${RELEASE}"

release: changelog update_release build

verify: bundle_install
	bundle exec rake test

bundle_install:
	bundle install --path $(BUNDLE_DIR)

acceptance: bundle_install
	exit 0
	#bundle exec rake beaker:default

test: validate run-spec lint

validate:
	bundle exec rake validate

run-spec:
	bundle exec rake spec SPEC_OPTS='--format documentation'

lint:
	bundle exec rake lint
