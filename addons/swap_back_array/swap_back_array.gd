class_name SwapBackArray
extends RefCounted

## A generic array of Nodes with O(1) append and O(1) removal-by-index using the
## swap-back technique. Holds no reverse lookup, so every mutation is the cheapest
## it can be. If you need O(1) find(item)/get_by_item, use [FindableSwapBackArray],
## which adds an instance-id side table at the cost of a hash op per mutation.
var _items: Array[Node] = []


## Appends an item to the array.
## [param item]: The Node to append.
func append(item: Node) -> void:
	if item != null:
		_items.append(item)


## Removes an item at the specified index using swap-back for O(1) performance.
## [param index]: The index of the item to remove (0-based).
func remove_at(index: int) -> void:
	if not _is_valid_index(index):
		return
	var last: int = _items.size() - 1
	if index != last:
		_items[index] = _items[last]
	_items.resize(last) # truncate; skips pop_back's discarded Variant return


## Returns the current number of items in the array.
## [returns]: The size of the array.
func size() -> int:
	return _items.size()


## Clears all items in the array.
func clear() -> void:
	_items.clear()


## Retrieves an item by its index.
## [param index]: The index of the item to retrieve (0-based).
## [returns]: The item at the index, or null if index is invalid.
func get_by_index(index: int) -> Node:
	return _items[index] if _is_valid_index(index) else null


## Checks if an index is valid.
## [param index]: The index to check.
## [returns]: True if the index is within bounds, false otherwise.
func _is_valid_index(index: int) -> bool:
	return index >= 0 and index < _items.size()
