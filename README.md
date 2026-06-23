<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="docs/images/logo-lockup-dark.svg">
    <img alt="SwapBackArray" src="docs/images/logo-lockup-light.svg" width="420">
  </picture>
</p>

# SwapBackArray Addon for Godot 4.4+

## Description

A lightweight Godot 4.4+ addon for efficient array management using the swap-back technique. Two classes for Nodes and a static helper for packed data:

- **`SwapBackArray`** — O(1) `append` and O(1) `remove_at(index)`. No reverse lookup, so every mutation is as cheap as possible. Use when you only ever remove by index.
- **`FindableSwapBackArray`** — extends the above and adds O(1) `find(item)` / `get_by_item(item)` via an instance-id side table. Pays one hash op per mutation. Use when you need "where is this node".
- **`SwapBackUtil`** — static O(1) `remove_at_*` helpers for `Packed*Array` value types (int/float/Vector/Color/String/byte). No wrapper object; you keep your own packed array and the helper swap-removes in place.

The contained Node's identity (name, groups, scene path) is never mutated.

## Installation

1. Copy the `addons/swap_back_array` folder to your project's `addons` directory.
2. Enable the addon in Godot: `Project > Project Settings > Plugins > SwapBackArray > Enable`.
3. The `SwapBackArray` class is now available globally.

## Usage

SwapBack Arrays are best used for order agnostic Nodes that need to be stored and quickly removed `(e.g: Inactive Characters)`

Index-only (fastest):

```gdscript
var array: SwapBackArray = SwapBackArray.new()
var obj: Node = Node.new()
array.append(obj)             # Adds obj in O(1)
array.remove_at(0)           # Removes obj in O(1) via swap-back
print(array.get_by_index(0)) # Returns null if invalid
array.clear()                # Clears array
```

With reverse lookup:

```gdscript
var array: FindableSwapBackArray = FindableSwapBackArray.new()
var obj: Node = Node.new()
array.append(obj)
print(array.find(obj))        # Returns index or -1
print(array.get_by_item(obj)) # Returns obj or null
array.remove_at(array.find(obj))
```

Packed data (no wrapper, in-place):

```gdscript
var ids: PackedInt32Array = [10, 20, 30, 40]
SwapBackUtil.remove_at_i32(ids, 1)  # ids == [10, 40, 30] — O(1), order not preserved

var points: PackedVector3Array = [a, b, c]
SwapBackUtil.remove_at_v3(points, 0)
```

One `remove_at_*` per packed type: `_byte`, `_i32`, `_i64`, `_f32`, `_f64`, `_str`, `_v2`, `_v3`, `_v4`, `_color`. Out-of-range index is a no-op.

## Choosing the right tool

| Your data | Use | Notes |
| --- | --- | --- |
| Scene-tree Nodes, remove by index only | `SwapBackArray` | Fast path, no reverse lookup |
| Scene-tree Nodes, need "where is this node" | `FindableSwapBackArray` | Adds O(1) `find`/`get_by_item`; ~3x mutation cost at 1M |
| Plain scalars/vectors (ids, positions) | `SwapBackUtil` + `Packed*Array` | No wrapper object; lightest option |

### Lifetime: the array does not own its Nodes

`SwapBackArray` stores **non-owning** references to Nodes. Nodes are not reference-counted, so:

- `remove_at` / `clear` only drop the node from the array — they do **not** free it. The node stays in the scene tree; free it yourself (`queue_free()`) if you want it gone.
- A node freed elsewhere becomes a dangling entry. `FindableSwapBackArray.find` guards against this (it verifies the stored node still matches the looked-up instance id), but `get_by_index` trusts the index — don't keep stale indices across frees.

The classes store `Node`, not `Object`, on purpose. The stored value is a pointer either way, so `Object` would not be "lighter" — it would only widen the contract and blur ownership (an `Array[Object]` holding a `RefCounted` *does* keep it alive, the opposite of the Node contract). For non-Node payloads use `SwapBackUtil`.

## Example
An example scene is in `addons/swap_back_array/example`. Open `example_scene_setup.tscn` to see `SwapBackArray` managing spawned `Node3D` instances.


## Benchmark results

`SwapBackArray` and `FindableSwapBackArray` were benchmarked against Godot's `Array` in Godot 4.8.dev (f964fa714), headless, on the following system:

- **OS**: CachyOS Linux #1 SMP PREEMPT_DYNAMIC Fri, 17 Oct 2025 10:40:14 +0000
- **Renderer**: Vulkan (Forward+), AMD Radeon RX 7900 XTX (RADV NAVI31)
- **CPU**: AMD Ryzen 7 7700X 8-Core Processor (16 threads)
- **Memory**: 30.45 GiB

Benchmark script/scene is in `addons/swap_back_array/benchmark`. Run `benchmark.tscn` for system-specific results.

### Removal performance

`SwapBackArray.remove_at` (O(1)) outperforms `Array.remove_at` (O(n)) at scale. Below ~10K elements the O(1) constant is larger than O(n) on small `n`, so plain `Array` wins — use this addon only when arrays get large.

| Size | Array (ms) | SwapBackArray (ms) | FindableSwapBackArray (ms) | Speedup vs Array | Findable overhead |
| --- | --- | --- | --- | --- | --- |
| 10 | 0.0001 | 0.0003 | 0.0003 | 0.14x | 1.00x |
| 100 | 0.0001 | 0.0003 | 0.0004 | 0.14x | 1.14x |
| 1K | 0.0001 | 0.0006 | 0.0008 | 0.23x | 1.31x |
| 10K | 0.0039 | 0.0020 | 0.0029 | 1.95x | 1.43x |
| 100K | 0.0544 | 0.0020 | 0.0056 | 26.51x | 2.71x |
| 1M | 0.6339 | 0.0023 | 0.0075 | 275.61x | 3.24x |

**Notes**:

- Averages over 20 runs, 5000 random removals per run.
- `SwapBackArray` (index-only) is the fast path: ~2x faster than `Array` at 10K, ~276x at 1M.
- `FindableSwapBackArray` pays for its instance-id side table — overhead grows from 1.0x (tiny) to ~3.2x (1M) over the base. Use it only when you need O(1) `find`/`get_by_item`; otherwise use the base.
- Below ~10K, `Array` is faster than either — the swap-back O(1) constant dominates.
- Run benchmark scripts for precise results.

## License

MIT License. See `LICENSE` for details.
