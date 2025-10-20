# SwapBackArray Addon for Godot 4.4+

## Description

A lightweight Godot 4.5 addon providing a `SwapBackArray` resource for efficient array management. Features O(1) removal and lookup using the swap-back technique, and using a Node.name for an index property.

## Installation

1. Copy the `addons/swap_back_array` folder to your project's `addons` directory.
2. Enable the addon in Godot: `Project > Project Settings > Plugins > SwapBackArray > Enable`.
3. The `SwapBackArray` class is now available globally.

## Usage

SwapBack Arrays are best used for order agnostic Nodes that need to be stored and quickly removed `(e.g: Inactive Characters)`

```gdscript
var array: SwapBackArray = SwapBackArray.new()
var obj: Node = Node.new()
array.append(obj)  # Adds obj, sets obj.name = 0
array.remove_at(0)  # Removes obj in O(1)
print(array.get_by_index(0))  # Returns null if invalid
print(array.find(obj))  # Returns index or -1
array.clear()  # Clears array
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
- `SwapBackArray` excels for removals, with speedup increasing with array size. Insertion performance is comparable to `Array.append`, with slight overhead from setting the `index` property.
- Run benchmark scripts for precise results.

## License

MIT License. See `LICENSE.txt` for details.
