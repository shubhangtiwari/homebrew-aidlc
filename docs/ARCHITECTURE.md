# Architecture

## Purpose

This document records the current architecture for the `homebrew-aidlc` scope. It gives agents and
maintainers the authoritative local map for governance, developer commands, and Homebrew formula
source placement for the `aidlc` tap.

## Scope

This repository is the Homebrew tap for `aidlc` installation. It owns governance files,
architecture documentation, project tooling, and Homebrew packaging source for the user-facing
`aidlc` install command.

## Primary Domain

`software`

## Adopted Reference

- Reference: `minimal-tooling`, adapted by `docs/architecture/software.md`
- Primary domain: `software`
- Status: initialized

The `minimal-tooling` reference still describes the governance shell of this small tap, while the
scope-local software profile defines the Homebrew packaging integration boundary for formula
source.

## Agent Protocol

- Resolve this directory as its own AIDLC scope root because it contains generated governance and
  `docs/spec/README.md`.
- Treat governed source, contracts, specs, architecture docs, ADRs, and blueprints as governed
  paths; run change classification before implementation work.
- For trivial or small governed changes, use inline intent and implementer execution after user
  confirmation.
- For medium, large, or uncertain governed changes, require an approved scope-local spec in
  `docs/spec/` before implementation.
- Execute repository commands through the root `Makefile`.
- Do not edit generated governance files by hand; regenerate them with `make init <ide>` or
  `make update`.
- Apply `docs/architecture/software.md` for Homebrew formula source, release metadata, and
  packaging integration rules.

## Directory Map

- `.ai/` - portable governance source, scripts, templates, skills, personas, and references.
- `.claude/` - generated Claude agent and skill guidance.
- `.codex/` - generated Codex agent and skill guidance.
- `.cursor/` - generated Cursor agents, rules, and skills.
- `.github/copilot-instructions.md` - generated GitHub Copilot guidance.
- `.github/workflows/finalize-spec.yml` - post-merge spec cleanup workflow.
- `docs/adr/` - architecture decision records.
- `docs/blueprints/` - module blueprints. No project blueprint is required yet.
- `docs/spec/` - governed implementation specs.
- `Formula/` - Homebrew formula source. Formula files are the tap's package manager integration
  boundary and must follow `docs/architecture/software.md`.
- `licenses/` - generated governance license notes.
- `AGENTS.md`, `CLAUDE.md`, `.windsurfrules` - generated IDE and agent instructions.
- `aidlc.lock.json` - generated governance lock metadata.
- `Makefile` - developer and governance command surface.
- `README.md` - tap overview.

There is currently no `Casks/`, source manifest, or application source tree. Cask support remains
out of scope until a future architecture update introduces it.

## Artifact Taxonomy

- Generated governance artifacts: `.ai/`, `.claude/`, `.codex/`, `.cursor/`,
  `.github/copilot-instructions.md`, `AGENTS.md`, `CLAUDE.md`, `.windsurfrules`,
  `aidlc.lock.json`, and generated license notes under `licenses/`.
- Local project artifacts: `README.md`, `Makefile`, `docs/ARCHITECTURE.md`, `docs/architecture/`,
  `docs/adr/`, `docs/blueprints/`, and `docs/spec/`.
- Homebrew tap artifacts: `Formula/` for formula definitions. `Formula/*.rb` integrates this tap
  with Homebrew and with the read-only upstream source release archive for `aidlc`.
- Future Homebrew tap artifacts: `Casks/` for cask definitions. This path does not exist yet and
  requires architecture refresh before governed source work begins.
- CI artifacts: `.github/workflows/finalize-spec.yml` for post-merge spec cleanup. Additional CI
  workflows should be documented here when introduced.

## Layer Laws

Use `docs/architecture/software.md` for formula source, release-source contracts, and tap command
rules. `Formula/*.rb` is an integration layer because it binds Homebrew's packaging DSL to
published upstream `aidlc` release artifacts.

Cask files and additional package manager integrations are not part of the current layer model.
Adding them requires a future architecture update.

## Execution & Developer Experience

All routine commands are exposed through the root `Makefile`.

- `make init <ide>` - regenerate governance files for the requested IDE using the installed
  `aidlc` command.
- `make update` - refresh governance files using the installed `aidlc` command.
- `make finalize-spec` - run post-merge spec cleanup through `.ai/scripts/finalize_spec.sh`.
- `make tap` - register this checkout as the `shubhangtiwari/aidlc` Homebrew tap.
- `make install` - install the local `aidlc` formula from source through Homebrew.
- `make upgrade` - update Homebrew metadata and upgrade the installed `aidlc` formula.
- `make uninstall` - uninstall the `aidlc` formula through Homebrew.
- `make run` - run the installed `aidlc` smoke test.
- `make lint` - audit the tap and style-check `Formula/aidlc.rb`.
- `make test` - audit, style-check, install, and run the Homebrew formula test.

These Makefile targets are the entrypoint for Homebrew tap registration, audit, style, install,
upgrade, uninstall, run, and test commands.

## Initialization Record

- Date: 2026-06-04
- Decision: Option A
- Reference id: `minimal-tooling`
- Result: initialized as a minimal tooling repository for the `aidlc` Homebrew tap.

## Architecture Refresh Record

- Date: 2026-06-04
- Spec: `docs/spec/1780578145-add-aidlc-formula.md`
- Decision: adopt a scope-local software profile for Homebrew formula packaging.
- Result: `Formula/*.rb` is the Homebrew packaging integration boundary for the tap.
