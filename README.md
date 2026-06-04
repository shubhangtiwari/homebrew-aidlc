# homebrew-aidlc

Homebrew tap for installing the `aidlc` CLI.

## Setup

Add the tap:

```sh
brew tap shubhangtiwari/aidlc
```

## Install

Install `aidlc` from the tap:

```sh
brew install aidlc
```

For local tap development, run the Makefile target from this repository:

```sh
make tap
make install
```

## Smoke test

Confirm the installed binary starts and reports its version:

```sh
aidlc version
```

The same smoke test is available through the Makefile:

```sh
make run
```

## Upgrade

Refresh Homebrew metadata and upgrade `aidlc`:

```sh
brew update
brew upgrade aidlc
```

Or use:

```sh
make upgrade
```

## Uninstall

Remove the installed CLI:

```sh
brew uninstall aidlc
```

Remove the tap if you no longer need it:

```sh
brew untap shubhangtiwari/aidlc
```

The package uninstall command is also available through:

```sh
make uninstall
```

## Verification

Tap verification is wrapped by the root Makefile:

```sh
make test
```

`make test` registers this checkout as the local `shubhangtiwari/aidlc` tap, runs Homebrew audit
for the tap and style checks for `Formula/aidlc.rb`, installs `shubhangtiwari/aidlc/aidlc` from
source, and runs the formula test block.
