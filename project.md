# ZForge Project Documentation

This document describes the current ZForge implementation and architecture.

It intentionally avoids the personal/portfolio voice of `README.md`. The README explains the project. This document explains the system.

---

## 1. Scope

ZForge is a zsh configuration build and runtime system.

It processes:

- module source
- module metadata
- runtime source
- enabled-module configuration
- boot/runtime/dynamic flags
- dependency information

and produces generated runtime state that can be loaded by zsh.

The project is currently Linux-oriented and zsh-specific.

---

## 2. Current repository footprint

The supplied current source tree contains:

| Area | Files | Lines |
|---|---:|---:|
| `runtime/` | 50 | 1,405 |
| `modules/` | 18 | 1,421 |
| **Total** | **70** | **2,826** |

The current module list contains 18 modules.

The current `local/public/runtime/module` enables 15 modules.

Those enabled modules contain 1,332 source lines.

These are source-footprint measurements. They must not be interpreted as the number of lines directly parsed during every warm boot.

---

## 3. Runtime model

The main entry point is:

```text
runtime/init
```

When sourced by zsh it initializes the runtime.

When executed as a script it exposes the CLI behavior.

The initialization path performs:

1. environment initialization
2. logger initialization
3. first-boot/bootstrap checks
4. CLI dispatch when executed directly
5. orchestration
6. shell API loading
7. generated runtime loading
8. foreground initialization timing

The runtime itself records the foreground initialization duration.

---

## 4. Cold boot

If no usable generated snapshot exists, the orchestrator performs generation in the foreground.

Conceptually:

```text
zsh
 ↓
runtime/init
 ↓
initialize environment
 ↓
bootstrap checks
 ↓
orchestrator
 ↓
generation
 ↓
publish snapshot
 ↓
load generated runtime
```

A cold boot therefore includes generation work.

---

## 5. Warm boot

If generated snapshot state exists, the orchestrator takes the warm path.

Conceptually:

```text
zsh
 ↓
runtime/init
 ├──────────────► generated runtime
 │                    │
 │                    ▼
 │                usable shell
 │
 └──────────────► background validation
```

The existing generated runtime is not discarded while validation occurs.

If the configuration has not changed, the existing snapshot can remain in use.

If a new generation is required, the result is prepared separately and becomes available for subsequent startup.

`FREEZE_BACKGROUND_VALIDATION` can disable background validation.

---

## 6. Performance measurement

A measured development configuration loads in approximately:

> **190 ms**

The stated configuration for that measurement has the relevant module disabled and tmux removed.

This is a project measurement, not a benchmark claim for all machines.

The source tree contains 2,826 lines across 70 runtime/module files, but that does not mean 2,826 lines are interpreted from scratch during every warm boot.

The generated runtime, snapshot reuse and lazy function machinery exist specifically to separate the size of the source system from the work required by a normal startup.

If future benchmarking is added, benchmark methodology should record:

- machine/CPU
- zsh version
- enabled modules
- disabled modules
- tmux state
- warm/cold state
- number of repeated runs
- whether background validation is enabled
- measured foreground time

The website should not imply that 190 ms is a universal result.

---

## 7. Fingerprinting

The fingerprinting layer calculates a SHA-256 configuration hash.

The fingerprint incorporates generation-relevant state such as:

- module configuration
- module source
- runtime source
- dependencies
- boot flags that affect generation

The purpose is change detection.

It allows the runtime to distinguish:

```text
same configuration
        ↓
reuse existing generated state
```

from:

```text
changed configuration
        ↓
generate a new state
```

Fingerprinting is therefore an optimization and consistency mechanism, not an instruction to rebuild on every shell startup.

---

## 8. Failed fingerprints

Generation failures are recorded against the relevant configuration fingerprint.

If the same fingerprint is encountered again, ZForge can avoid repeatedly attempting the same known-bad generation.

This prevents a broken configuration from creating an identical generation failure on every shell startup.

---

## 9. Snapshot reuse

Generated snapshots are indexed by configuration hash.

When the current configuration corresponds to a previously generated state, ZForge can reuse that state rather than regenerating it.

This also means returning to a previous configuration can recover an existing generated snapshot.

---

## 10. Atomic generation

Generation writes candidate output separately and publishes it only after generation succeeds.

The intended lifecycle is:

```text
source
  ↓
candidate generation
  ↓
validation/completion
  ↓
publish
```

rather than:

```text
source
  ↓
overwrite active runtime continuously
```

This is important because an incomplete generation should not replace the known-good runtime.

---

## 11. Module metadata

Modules are ordinary zsh files with comment-based metadata.

### Priority

```zsh
# @p -> 50
```

Defines module priority.

### Dependency

```zsh
# @d -> tmux_terminal
```

Declares another enabled module as a dependency.

### Dynamic flag

```zsh
# @f -> MY_FLAG
```

Registers a dynamic flag.

### Environment

```zsh
# @e -> MY_VARIABLE
```

Declares an environment variable used by the module.

### Merge control

```zsh
# @nomerge
```

Keeps a module outside the normal merged master-file path.

### Lazy control

```zsh
# @lazy
```

Requests lazy handling.

```zsh
# @nolazy
```

Disables lazy handling for that module.

---

## 12. Dependency and priority analysis

The analyzer performs checks including:

- dependency presence
- dependency sorting
- circular dependency detection
- priority/dependency conflicts

A module whose declared dependency is not enabled is rejected rather than silently ignored.

The current system does not yet have a complete resource-conflict model between modules.

That is part of the remaining work.

---

## 13. Generation

The generator transforms modules into generated runtime state.

The generated master file wraps merged module content in a function scope:

```zsh
(){
    # generated module body
}
```

This provides isolation for module-level `return`.

Modules marked `@nomerge` are sourced separately instead.

---

## 14. Lazy generation

ZForge contains a text-based analyzer for functions.

Functions can be replaced with wrappers that load the real implementation when first invoked.

The objective is to reduce startup work for functionality that is not needed immediately.

The analyzer is not a complete zsh parser.

Therefore:

- unusual shell syntax may not be understood
- `@nolazy` provides an escape hatch
- tests should cover representative function definitions

The syntax-checking stage exists in the architecture but is currently stubbed and remains TODO work.

---

## 15. Flags

There are three categories of flags.

### Boot flags

Stored under:

```text
local/public/runtime/bootflags
```

Examples in the current configuration include:

```text
SILENT_LOG
LOGALL
FREEZE_BACKGROUND_VALIDATION
```

### Runtime flags

Stored under:

```text
local/public/runtime/flags
```

### Dynamic flags

Declared by modules using:

```zsh
# @f -> FLAG_NAME
```

The current runtime exposes interactive flag management through:

```text
:flags
```

---

## 16. Logging

The logger provides debug/warn/error output and maintains a per-session log under `/dev/shm`.

The generated snapshot can retain generation logs.

Debugging can embed module identifiers through:

```text
EMBED_FILE_ID_FOR_DEBUG
```

The shell interface includes:

```text
:log
```

for inspecting the session log.

---

## 17. Current modules

The repository currently contains 18 modules:

```text
activateVenv
ascii_art_fastfetch
env_flags
fzfForPreviousCmd
gitPass
gocryptfs
homebrew
inline_buffer_editor
loadBins
omz
omz_helper
persistentAlias
pokemon-fastfetch
sdkman
sudo_systemd_ask_pass
tmux_terminal
track_config
z
```

The current runtime configuration enables 15 of them.

The module source footprint of those enabled modules is 1,332 lines.

---

## 18. Public/private configuration

The repository separates public and private state.

```text
local/public/
local/private/
```

Private state is intended to remain outside normal public repository content.

The gocryptfs module provides encrypted private configuration handling.

The encrypted representation and decrypted runtime state should not be conflated. Once decrypted/mounted, the content is available to the local environment.

---

## 19. External dependencies

The core project and individual modules depend on external system tools.

Examples include tools used by the enabled module set such as:

- zsh
- fzf
- uuidgen
- tmux
- zoxide
- gocryptfs
- jq
- htmlq
- fastfetch
- system utilities

The current system does not yet provide a general dependency declaration/diagnostic mechanism for all modules.

That is planned work.

---

## 20. Platform assumptions

The implementation currently assumes a Linux-like environment and zsh.

Parts of the implementation rely on behavior or tools including:

- `/dev/shm`
- `grep -P`
- GNU-style command behavior
- `realpath`
- `find`

macOS compatibility has not been established and should not be presented as supported until it is tested.

---

## 21. Current development status

The project is functional.

Remaining work is divided into:

1. correctness/cleanup
2. generation safety
3. module conflict handling
4. dependency diagnostics
5. snapshot management
6. new-machine setup
7. developer tooling

Experimental ideas are intentionally kept separate from current work.

See `TODO.md`.

---

## 22. Performance claims policy

The project currently has one useful measured number:

> approximately 190 ms for the specified warm-start development configuration.

Documentation should always include the configuration when presenting this value.

Do not convert this into claims such as:

- "ZForge always starts in 190 ms"
- "ZForge is faster than X"
- "ZForge has zero performance cost"

The correct statement is that fingerprinting and background validation are designed to avoid unnecessary regeneration, and a measured configuration currently loads in approximately 190 ms.

---

## 23. Architectural boundary

ZForge is not intended to become all of the following at once:

```text
shell configuration
+
package manager
+
dotfile manager
+
system updater
+
secret manager
+
machine provisioning system
+
backup system
```

Some of those ideas exist in the TODO as experiments.

They should remain explicitly experimental until there is a clear reason for them to belong in the core project.

The current architectural center is:

```text
modular zsh source
        ↓
analysis
        ↓
fingerprint
        ↓
generation
        ↓
snapshot
        ↓
runtime
```

---

## 24. Documentation relationship

The documentation has three different jobs:

### `README.md`

Public explanation and project personality.

### `project.md`

Technical reference.

### `TODO.md`

Development state:

- completed work
- current work
- ideas

The three files should not duplicate each other unnecessarily.

---

## 25. Project links

- GitHub: https://github.com/sanjay-kr-commit/zforge
- Project page: https://sanjay-kr-commit.github.io/projects/zforge/
- Portfolio: https://sanjay-kr-commit.github.io/
