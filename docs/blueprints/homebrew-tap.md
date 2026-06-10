# Homebrew Tap Blueprint

## Purpose and Scope

The `homebrew-aidlc` module owns the Homebrew tap contract for installing the `aidlc` CLI. It owns
the `Formula/aidlc.rb` formula, the user-facing tap command surface documented in `README.md`, and
the Makefile-wrapped verification targets for local tap development.

This module does not own the upstream `aidlc` CLI source code. It packages a verified upstream
release artifact and exposes Homebrew install, upgrade, uninstall, verification, and smoke-test
commands for the tap.

## Layer Map

| Layer | Paths | Responsibility |
| --- | --- | --- |
| API | `README.md`, user-facing `Makefile` targets | Document and expose tap setup, install, upgrade, uninstall, test, and run commands. |
| Integrations | `Formula/aidlc.rb` | Translate the verified upstream source archive into Homebrew build, install, and formula test behavior. |
| Models | `docs/ARCHITECTURE.md`, `docs/architecture/software.md`, `docs/blueprints/*.md`, `docs/spec/*.md` | Record tap architecture, contracts, ownership, and implementation plans. |
| Tooling | `Makefile`, generated governance files | Provide local verification and governance commands. |

## Public Contracts

| Contract | Value |
| --- | --- |
| Tap | `shubhangtiwari/aidlc` |
| Formula name | `aidlc` |
| Public install command | `brew tap shubhangtiwari/aidlc` then `brew install aidlc` |
| Local install command | `make tap` then `make install` |
| Installed binary | `aidlc` |
| Smoke-test command | `aidlc version` or `make run` |
| Current upstream tag | `aidlc/v0.7.0` |
| Formula version | `0.7.0`, derived from the verified upstream tag |
| Source archive | `https://github.com/shubhangtiwari/aidlc/archive/refs/tags/aidlc/v0.7.0.tar.gz` |
| Source checksum | `fa362b240674f1f1a8fceffd159f3ffe83c8917c23c32ed6ee942acc224d8f87` |
| License | `MIT` |

The formula builds from the nested upstream Go module at `aidlc/` in the release archive. The
installed binary must report meaningful version metadata; for the current formula, the Go linker
sets `github.com/shubhangtiwari/aidlc/aidlc/internal/commands.Version` to the Homebrew formula
version, and the formula test asserts `aidlc 0.7.0` style output from `aidlc version`.

Formula updates must use a remotely verifiable upstream tag, a stable GitHub source archive URL, and
the SHA256 checksum for that exact archive. Placeholder checksums, local-only tags, and versions
guessed from working-tree files are not valid tap contracts.

## Owned State

This module does not own durable runtime state. Homebrew installation state lives outside the
repository in the user's Homebrew prefix. Local development may symlink this checkout into
Homebrew's tap directory through `make tap`; that symlink is external tool state, not repository
state.

## Read-Only Paths

The upstream source repository at `https://github.com/shubhangtiwari/aidlc.git` is a read-only
release source boundary for this tap. The tap may consume published release archives from that
repository, but must not edit or depend on sibling checkout paths such as
`/Users/shubhangtiwari/git/aidlc/aidlc`.

## Integration Boundaries

Homebrew is the package manager integration boundary. `Formula/aidlc.rb` is the only source path in
this module that may use Homebrew formula DSL APIs such as `url`, `sha256`, `license`, `depends_on`,
`def install`, and `test do`.

The GitHub release archive is the upstream source integration boundary. Formula changes must verify
the upstream tag, source URL, checksum, and license before declaring a new release. If any of those
values cannot be verified, implementation must stop instead of shipping a partial formula.

## Test Gates

Formula, command-surface, and blueprint changes for this module must run through Makefile targets:

| Gate | Required coverage |
| --- | --- |
| `make lint` | Registers the local tap, runs `brew audit --strict --online --tap shubhangtiwari/aidlc`, and runs `brew style Formula/aidlc.rb`. |
| `make test` | Runs `make lint`, installs `shubhangtiwari/aidlc/aidlc` from source, and runs `brew test shubhangtiwari/aidlc/aidlc`. |
| `make install` | Registers this checkout as the local tap and installs the local formula from source. |
| `make run` | Runs the installed `aidlc version` smoke test. |

All Homebrew verification for this tap must stay wrapped by the root `Makefile`; do not introduce
ad hoc scripts or direct-only verification commands as the documented gate.
