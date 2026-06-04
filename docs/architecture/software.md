# Software Domain Architecture

This profile adapts the minimal tap repository into a software packaging scope. The tap does not
own the `aidlc` CLI source code; it owns the Homebrew contract that installs a verified upstream
release artifact.

## Scope Model

The invocation root for this profile is `/Users/shubhangtiwari/git/aidlc/homebrew-aidlc`. Files in
this scope belong to the Homebrew tap unless a future nested AIDLC scope is initialized below this
directory.

The upstream CLI source repository is outside this scope. The tap may consume published release
artifacts from `https://github.com/shubhangtiwari/aidlc.git`, but it must not modify or depend on
private working-tree state from the upstream repository.

## Layer Map

| Layer | Paths | Responsibility |
| --- | --- | --- |
| API | `README.md`, user-facing Makefile targets | Document and expose tap commands such as setup, install, upgrade, uninstall, test, and run. |
| Integrations | `Formula/*.rb` | Bind Homebrew's formula DSL to a verified upstream `aidlc` release archive. |
| Models | `docs/ARCHITECTURE.md`, `docs/architecture/software.md`, `docs/blueprints/*.md`, `docs/spec/*.md` | Record architecture, contracts, ownership, and implementation plans. |
| Tooling | `Makefile`, generated governance files | Provide Makefile-wrapped local verification and governance commands. |

## Laws

1. `Formula/*.rb` is the Homebrew packaging integration boundary.
2. Formula files must consume published upstream release archives, not sibling checkout paths or
   mutable local files.
3. The tap must treat `https://github.com/shubhangtiwari/aidlc.git` as a read-only upstream source
   boundary.
4. User-visible install behavior and verification commands must be exposed through the root
   `Makefile` and README, not through ad hoc scripts.
5. The formula must not contain placeholder release metadata.
6. Casks, bottles, binary-only installs, and alternate package managers require an architecture
   update before implementation.

## Homebrew Integration Boundary

`Formula/*.rb` is the only source layer that may call Homebrew formula APIs such as `url`, `sha256`,
`license`, `depends_on`, `def install`, and `test do`. Formula files translate a verified upstream
`aidlc` release into Homebrew install behavior.

The formula may build from the nested upstream Go module at `aidlc/` in the release archive, whose
module path is `github.com/shubhangtiwari/aidlc/aidlc`. It must not reach outside Homebrew's build
path to use `/Users/shubhangtiwari/git/aidlc/aidlc` or any other local checkout.

## Release Source Contract

Before any formula is written or updated, the implementer must verify and record these release
source values:

| Value | Required rule |
| --- | --- |
| GitHub tag | A remotely verifiable tag in `https://github.com/shubhangtiwari/aidlc.git`, expected to use the `aidlc/vX.Y.Z` shape unless a future upstream release contract changes it. |
| Version | The Homebrew formula version derived from the verified tag, without guessing from local files. For `aidlc/vX.Y.Z`, the formula version is `X.Y.Z`. |
| Source tarball URL | A stable GitHub source archive URL for the verified tag, such as `https://github.com/shubhangtiwari/aidlc/archive/refs/tags/aidlc/vX.Y.Z.tar.gz`. |
| Checksum | The SHA256 of the exact source tarball URL that the formula declares. |
| License | The license observed in the verified release artifact; use `MIT` only when the artifact confirms the upstream license remains MIT. |

Implementation must stop before shipping a formula if any required value cannot be verified. Do not
commit placeholder values, guessed checksums, local-only tags, or URLs that cannot be fetched and
hashed.

## Review Checklist

Use this checklist for software-domain tap changes:

1. The change stays inside `/Users/shubhangtiwari/git/aidlc/homebrew-aidlc`.
2. Formula changes use only verified release source metadata.
3. Homebrew commands run through `make` targets.
4. Blueprint updates are made when public install contracts, integration boundaries, read-only
   upstream source boundaries, or test gates change.
5. No upstream `aidlc` source files are edited from this tap scope.
