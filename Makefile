.DEFAULT_GOAL := help

AIDLC ?= aidlc
ARGS ?=
BREW ?= brew
FORMULA ?= Formula/aidlc.rb
FORMULA_NAME ?= aidlc
TAP ?= shubhangtiwari/aidlc
TAP_FORMULA ?= $(TAP)/$(FORMULA_NAME)

.PHONY: help init update finalize-spec tap install upgrade uninstall run lint test check-formula claude codex cursor copilot windsurf all

help:
	@printf '%s\n' 'Usage: make <target> [ARGS="..."]'
	@printf '%s\n' ''
	@printf '%s\n' 'Governance targets:'
	@printf '%s\n' '  make init <ide>       Regenerate governance files for an IDE via aidlc'
	@printf '%s\n' '  make update           Refresh governance files via aidlc'
	@printf '%s\n' '  make finalize-spec    Finalize merged specs after PR merge'
	@printf '%s\n' ''
	@printf '%s\n' 'Project targets:'
	@printf '%s\n' '  make tap              Register this checkout as the shubhangtiwari/aidlc tap'
	@printf '%s\n' '  make install          Install the local aidlc formula from source'
	@printf '%s\n' '  make upgrade          Update Homebrew metadata and upgrade aidlc'
	@printf '%s\n' '  make uninstall        Uninstall the aidlc formula'
	@printf '%s\n' '  make run              Run the installed aidlc smoke test'
	@printf '%s\n' '  make lint             Audit the tap and style-check the formula'
	@printf '%s\n' '  make test             Audit, style, install, and test the local formula'

init:
	@ide="$(filter-out $@,$(MAKECMDGOALS))"; \
	if [ -z "$$ide" ]; then \
		printf '%s\n' 'usage: make init <ide>'; \
		exit 2; \
	fi; \
	$(AIDLC) init "$$ide" $(ARGS)

update:
	$(AIDLC) update $(ARGS)

finalize-spec:
	bash .ai/scripts/finalize_spec.sh $(ARGS)

tap:
	@set -e; \
	tap="$(TAP)"; \
	owner="$${tap%/*}"; \
	repo="$${tap#*/}"; \
	homebrew_repo="$$($(BREW) --repository)"; \
	tap_dir="$$homebrew_repo/Library/Taps/$$owner/homebrew-$$repo"; \
	current_dir="$$(pwd -P)"; \
	if [ -e "$$tap_dir" ]; then \
		tap_real="$$(cd "$$tap_dir" && pwd -P)"; \
		if [ "$$tap_real" = "$$current_dir" ]; then \
			exit 0; \
		fi; \
		$(BREW) untap $(TAP); \
	fi; \
	mkdir -p "$$(dirname "$$tap_dir")"; \
	ln -s "$$current_dir" "$$tap_dir"

install: check-formula tap
	$(BREW) install --build-from-source $(TAP_FORMULA)

upgrade:
	$(BREW) update
	$(BREW) upgrade $(FORMULA_NAME)

uninstall:
	$(BREW) uninstall $(FORMULA_NAME)

run:
	$(AIDLC) version

lint: check-formula tap
	$(BREW) audit --strict --online --tap $(TAP)
	$(BREW) style $(FORMULA)

test: lint
	$(BREW) install --build-from-source $(TAP_FORMULA)
	$(BREW) test $(TAP_FORMULA)

check-formula:
	@if [ ! -f "$(FORMULA)" ]; then \
		printf '%s\n' 'Formula/aidlc.rb is required before this target can run. Complete WP-F1 first.'; \
		exit 2; \
	fi

claude codex cursor copilot windsurf all:
	@:
