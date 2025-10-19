
# SwapBackArray Addon for Godot 4.5

## Description
A lightweight Godot 4.5 addon providing a `SwapBackArray` resource for efficient array management. Features O(1) removal using the swap-back technique, type enforcement via `Variant.Type`, and automatic naming/freeing for `TYPE_OBJECT` items (e.g., `Node3D`).

## Installation
1. Copy the `addons/swap_back_array` folder to your project's `addons` directory.
2. Enable the addon in Godot: `Project > Project Settings > Plugins > SwapBackArray > Enable`.
3. The `SwapBackArray` class is now available globally.

## Usage
```gdscript
# Create a SwapBackArray for Node3D
var array = SwapBackArray.new(TYPE_OBJECT)
var node = Node3D.new()
array.append(node)  # Adds node, names it "0"
array.remove(0)     # Removes node, frees it
print(array.get_by_index(0))  # Access items
array.clear()       # Frees all TYPE_OBJECT items
```

## Example
An example scene is included in `addons/swap_back_array/example`. Open `example_scene.tscn` to see `SwapBackArray` in action, spawning and removing `Node3D` instances.

## License
MIT License. See `LICENSE.txt` for details.
