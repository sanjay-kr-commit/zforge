# TODO

ZForge is a working personal zsh environment. This file records the major work
that has already been completed and the work that remains.

Completed work is kept here intentionally. It provides context for what the
project already does instead of making this file look like a list of unfinished
ideas.

---

## Completed

### Runtime and generation

- [x] Restrict runtime to zsh and bail out cleanly elsewhere
- [x] First boot checks required bootstrap tools and creates local state
- [x] First boot generates the initial snapshot
- [x] `runtime/init` works as a CLI
- [x] `zforge --generate`
- [x] `zforge --generate --silent`
- [x] `zforge --chmodx`
- [x] Atomic generation using temporary output followed by publication
- [x] Runtime generation and module merging
- [x] Module isolation using generated function wrappers
- [x] `@nomerge`
- [x] Shell API cached stub

### Logging and debugging

- [x] Per-session debug/warn/error logging
- [x] Session log in `/dev/shm`
- [x] `:log`
- [x] `SILENT_LOG`
- [x] Generation logs retained with generated state
- [x] `EMBED_FILE_ID_FOR_DEBUG`

### Module system

- [x] `:module` interactive module picker
- [x] `@p` priority metadata
- [x] `@d` dependency metadata
- [x] `@f` dynamic flag metadata
- [x] `@e` environment metadata
- [x] Dependency sorting
- [x] Circular dependency detection
- [x] Priority/dependency conflict detection
- [x] Error when a declared dependency is not enabled
- [x] `@lazy`
- [x] `@nolazy`
- [x] `@nomerge`

### Flags

- [x] `:flags` picker
- [x] Boot flags
- [x] Runtime flags
- [x] Dynamic module flags
- [x] `INSTANT_REGENERATION`

### Fingerprints and snapshots

- [x] SHA-256 configuration fingerprints
- [x] Fingerprints include generation-relevant module/runtime/dependency state
- [x] Background revalidation
- [x] Load the existing good snapshot while validation runs
- [x] Record failed fingerprints
- [x] Avoid repeatedly regenerating a known-failed fingerprint
- [x] Reuse an existing snapshot when configuration returns to it

### Modules

- [x] `activateVenv`
- [x] `ascii_art_fastfetch`
- [x] `env_flags`
- [x] `fzfForPreviousCmd`
- [x] `gitPass`
- [x] `gocryptfs`
- [x] `homebrew`
- [x] `inline_buffer_editor`
- [x] `loadBins`
- [x] `omz`
- [x] `omz_helper`
- [x] `persistentAlias`
- [x] `pokemon-fastfetch`
- [x] `sdkman`
- [x] `sudo_systemd_ask_pass`
- [x] `tmux_terminal`
- [x] `track_config`
- [x] `z`

---

# Current work

These items have a concrete reason to be worked on.

## Correctness and cleanup

- [ ] Fix `pokemon-fastfetch` and `tmux_terminal` paths using the old
      `config/static_config/public/...` layout.
- [ ] Fix the missing slash in `omz_helper`'s `$_zforge_root_local` path.
- [ ] Fix `:list_env`.
- [ ] Fix `check_priority_to_dependency_conflict` error propagation.
- [ ] Replace plaintext token handling in `gitPass` with a credential helper.
- [ ] Standardize temporary-file creation.
- [ ] Validate `@e` and `@f` names during generation.
- [ ] Remove obsolete commented-out code from `hash_modules`.
- [ ] Add examples for the `:` commands to the documentation.

## Generation safety

- [ ] Restore generated-script syntax checking.
- [ ] Add tests that source a generated snapshot in a clean zsh.
- [ ] Test dependency ordering and cycle detection.
- [ ] Test snapshot reuse.
- [ ] Test failed-generation handling.
- [ ] Test lazy wrappers against representative zsh syntax.
- [ ] Surface background-generation failures instead of failing quietly.

## Module/resource conflicts

- [ ] Detect two modules registering the same dynamic flag.
- [ ] Detect modules touching the same resource.
- [ ] Define how conflicting modules should be handled.
- [ ] Detect enable/disable conflicts during generation.

## External dependencies

- [ ] Let modules declare required external commands.
- [ ] Check missing commands during generation.
- [ ] Add `:doctor` for dependency diagnostics.
- [ ] Decide whether ZForge should install missing dependencies or only report them.

## Snapshot management

- [ ] Add `:snapshots`.
- [ ] List and inspect snapshots.
- [ ] Add snapshot deletion/garbage collection.
- [ ] Add explicit rollback.
- [ ] Decide whether snapshot pinning is necessary.
- [ ] Consider per-module startup timing.

## New-machine setup

- [ ] Create a clean bootstrap script.
- [ ] Document the minimal installation process.
- [ ] Add a fresh-environment generation test.
- [ ] Document Linux-specific assumptions.
- [ ] Investigate macOS compatibility before promising support.

## Developer tooling

- [ ] Add `zforge new <module>`.
- [ ] Add `zforge lint`.
- [ ] Add `zforge explain <module>`.
- [ ] Add dependency graph inspection.
- [ ] Add shell completions where useful.

---

# Ideas

These are possibilities, not commitments.

## Module relationships

- [ ] `@conflicts`
- [ ] `@provides`
- [ ] `@owns`
- [ ] `@after` / `@before`
- [ ] Optional dependencies

## External packages

- [ ] `@needs-cmd`
- [ ] `:doctor` expansion
- [ ] `:install-missing`
- [ ] Include relevant external-command state in fingerprints
- [ ] Skip an unavailable module with a visible reason instead of failing halfway

## Snapshots

- [ ] Per-module copy-forward
- [ ] Quarantine a module that repeatedly fails
- [ ] `zcompile` experimentation

## New-machine setup

- [ ] Machine profiles
- [ ] Package backup/restore
- [ ] Configuration backup/restore improvements
- [ ] Investigate macOS support

## Modules

- [ ] `ssh_agent`
- [ ] `cheatsheet`
- [ ] Project-specific environment handling
- [ ] External-tool updater
- [ ] Prompt integrations
