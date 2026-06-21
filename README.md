# SwapBackArray Addon for Godot 4.4+

## Description

A lightweight Godot 4.5 addon for efficient array management using the swap-back technique. Two classes:

- **`SwapBackArray`** — O(1) `append` and O(1) `remove_at(index)`. No reverse lookup, so every mutation is as cheap as possible. Use when you only ever remove by index.
- **`FindableSwapBackArray`** — extends the above and adds O(1) `find(item)` / `get_by_item(item)` via an instance-id side table. Pays one hash op per mutation. Use when you need "where is this node".

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

## Example
An example scene is in `addons/swap_back_array/example`. Open `example_scene.tscn` to see `SwapBackArray` managing custom objects.


## Benchmark Results

`SwapBackArray` was benchmarked against Godot's `Array` in Godot 4.6.dev (b350b01b9) on the following system:

- **OS**: CachyOS Linux #1 SMP PREEMPT_DYNAMIC Fri, 17 Oct 2025 10:40:14 +0000
- **Renderer**: Vulkan (Forward+), AMD Radeon RX 7900 XTX (RADV NAVI31)
- **CPU**: AMD Ryzen 7 7700X 8-Core Processor (16 threads)
- **Memory**: 30.45 GiB

Benchmark script/scene is in `addons/swap_back_array/benchmark`. Run `benchmark.tscn` for system-specific results.

### Removal Performance

`SwapBackArray.remove_at` (O(1)) outperforms `Array.remove_at` (O(n)).

| Size | Array (ms) | SwapBackArray (ms) | Speedup |
| --- | --- | --- | --- |
| 10 | 0.0001 | 0.0016 | 0.06x |
| 100 | 0.0001 | 0.0016 | 0.03x |
| 1K | 0.0001 | 0.0015 | 0.10x |
| 10K | 0.0039 | 0.0017 | 2.27x |
| 100K | 0.0511 | 0.0016 | 31.94x |
| 1M | 0.5462 | 0.0015 | 352.39x |

**Notes**:

- Averages over 20 runs, 5000 operations.
- `SwapBackArray` excels for removals, with speedup increasing with array size. Insertion is comparable to `Array.append`. `FindableSwapBackArray` adds slight per-mutation overhead from maintaining its instance-id side table — see the benchmark's "Findable side-table overhead" line.
- Run benchmark scripts for precise results.

## License

MIT License. See `LICENSE.txt` for details.
