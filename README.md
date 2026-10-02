# ZForge

> A build system for a zsh environment that started as a way to keep one shell configuration from becoming one enormous `.zshrc`.

ZForge is a personal Linux/zsh project. It takes shell modules, their metadata, dependencies, flags and configuration, builds a generated runtime snapshot, and lets zsh start from that generated state.

The interesting part is not that it has a lot of machinery.

The interesting part is **why the machinery appeared**.

A growing shell configuration eventually needs ordering. Ordering needs dependencies. Rebuilding needs change detection. Change detection leads to fingerprints. Generated state needs safe replacement. Safe replacement leads to snapshots. Startup time eventually makes lazy loading useful.

So the project gradually became this:

```text
modules
   ↓
metadata
   ↓
dependency + priority analysis
   ↓
fingerprint
   ↓
generation
   ↓
snapshot
   ↓
zsh
```

It is still just zsh underneath.

---

## What it does

ZForge currently provides:

- modular zsh configuration
- module priorities and dependencies
- dynamic, runtime and boot flags
- content-based SHA-256 fingerprints
- generated runtime snapshots
- background revalidation on warm boots
- failed-generation tracking
- lazy function generation
- isolated module execution
- generated shell API
- per-session logging
- public/private configuration separation
- modules for things like tmux, fzf, gocryptfs, git configuration, fastfetch and environment handling

The repository currently contains **18 modules**, with **15 enabled in the current runtime configuration**.

The runtime and module source contains about **2,826 lines across 70 source files**. That is the source system, not a claim about how many lines zsh executes during every startup.

---

## Fingerprinting does not mean a rebuild every time

ZForge uses fingerprints precisely so it does **not** have to repeatedly regenerate an unchanged environment.

On a warm boot, the existing generated snapshot is loaded while ZForge checks whether the source/configuration state has changed.

Conceptually:

```text
warm boot

        existing snapshot
               │
               ├──────────────► load now
               │
               ▼
        fingerprint/check
               │
        ┌──────┴──────┐
        │             │
      unchanged     changed
        │             │
      reuse       regenerate
```

The current implementation records the foreground initialization time itself, and the measured configuration used during development has loaded the shell in roughly **190 ms with the relevant module disabled and tmux removed from the configuration**.

That number is a measurement from this environment, not a universal benchmark.

The important point is that fingerprinting is not intended to turn every shell startup into a build. It exists to avoid doing unnecessary work.

---

## There is a lot of source, but not all of it is startup work

The current tree contains:

| Source | Files | Lines |
|---|---:|---:|
| `runtime/` | 50 | 1,405 |
| `modules/` | 18 | 1,421 |
| **Total** | **70** | **2,826** |

The 15 currently enabled modules account for **1,332 lines**.

Those numbers describe the source available to the build system. Warm boot does not simply concatenate and parse every source file from scratch. ZForge uses generated state, snapshots and lazy wrappers so that the startup path can remain much smaller than the total project source.

That distinction is one of the reasons the project exists.

---

## Why I built it

I did not start with the goal of making a shell framework.

I had a shell configuration that kept growing.

Eventually there were enough unrelated things in it that "just add another function" stopped feeling free.

ZForge is the result of repeatedly asking:

> Can this part of my shell configuration be made easier to reason about?

The answer kept producing another small piece of infrastructure.

The result is a project that is more complicated internally than the website needs to be.

That is intentional.

---

## A small example

A module can remain ordinary zsh:

```zsh
#!/bin/env zsh

# @p -> 50
# @d -> tmux_terminal
# @f -> MY_FEATURE

my_feature() {
    ...
}
```

The comments give ZForge information about how the module participates in generation.

That means the module itself does not need a new programming language.

---

## Snapshots

A generated configuration is treated as a build artifact.

```text
source
  │
  ▼
build candidate
  │
  ├── success ──► publish snapshot
  │
  └── failure ──► keep previous snapshot
```

ZForge records fingerprints for generated states and failed states.

If a configuration returns to an older known-good state, its existing snapshot can be reused.

That makes the cache more than a speed trick. It is also part of the runtime's recovery model.

---

## Current state

ZForge is already a functioning system, but it is still a personal project.

Current work is mostly around:

- generation safety and tests
- module/resource conflict detection
- external dependency diagnostics
- snapshot inspection and rollback
- clean-machine bootstrap
- developer tooling
- a handful of existing bugs and cleanup items

There is also a separate list of ideas. Those are deliberately not presented as commitments.

See [`TODO.md`](TODO.md) for both the completed work and the remaining work.

---

## Links

- [GitHub repository](https://github.com/sanjay-kr-commit/zforge)
- [ZForge project page](https://sanjay-kr-commit.github.io/projects/zforge/)
- [Portfolio](https://sanjay-kr-commit.github.io/)

For the technical internals, see [`project.md`](project.md).

---

## The short version

ZForge is a personal experiment that grew into a small build system for zsh.

It fingerprints configuration instead of rebuilding blindly.

It generates snapshots instead of treating `.zshrc` as the whole runtime.

It keeps the last working state when generation fails.

And it tries to keep startup small even though the machinery underneath has become considerably less small.

That is pretty much the project.
