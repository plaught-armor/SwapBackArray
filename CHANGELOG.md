# Changelog

All notable changes to this addon are documented here.
Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/);
this project adheres to [Semantic Versioning](https://semver.org/).

## [2.0.0] - 2026-06-21

### Changed (breaking)

- `SwapBackArray` is now **index-only**: `find` / `get_by_item` moved to the new
  `FindableSwapBackArray`. Code relying on `SwapBackArray.find(...)` must switch
  to `FindableSwapBackArray` or remove the call.
- The addon no longer mutates `Node.name` for bookkeeping. Index lookup now lives
  in an instance-id side table, so the contained Node's identity (name, groups,
  scene path) is left untouched.
- `remove_at` uses `resize()` instead of `pop_back()` (skips the discarded Variant).

### Added

- `FindableSwapBackArray` — extends `SwapBackArray`, adding O(1) `find(item)` /
  `get_by_item(item)` via an instance-id side table (one hash op per mutation).
- `SwapBackUtil` — static O(1) swap-back removal helpers for `Packed*Array` value
  types (`_byte`/`_i32`/`_i64`/`_f32`/`_f64`/`_str`/`_v2`/`_v3`/`_v4`/`_color`).
- Benchmark now compares Standard Array / SwapBackArray / FindableSwapBackArray
  and reports the side-table overhead. README documents measured results.

### Fixed

- `remove_at` had an inverted validity guard: valid removals were no-ops and the
  swap-back path ran on invalid indices (out-of-bounds risk).
- Example called `array.get(index)`, which resolved to `Object.get(property)` and
  returned a null Variant; corrected to `get_by_index`.
- `find` now verifies the stored Node still matches the looked-up instance id,
  rejecting stale instance-id reuse instead of trusting the table blindly.
- Example replaced a release-stripped `assert()` with a `push_error` guard and
  parents spawned instances to itself rather than the scene root.
- Benchmark frees every created node (swap-removed nodes were leaked), un-shadows
  `@export` params, types its loop variable, and uses `maxf`.

## [1.0.0]

- Initial release: `SwapBackArray` with O(1) swap-back removal and name-based
  index lookup for Nodes.
