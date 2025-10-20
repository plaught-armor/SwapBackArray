class_name SwapBackArray
extends RefCounted

## A generic array of Nodes with O(1) removal and lookup using swap-back technique.
## Nodes are renamed to their index as a string for O(1) lookup.
var _items: Array[Node] = []


## Appends an item to the array and sets its name to its index.
## [param item]: The Node to append.
func append(item: Node) -> void:
	if item == null:
		return
	item.name = str(_items.size())
	_items.append(item)


## Removes an item at the specified index using swap-back for O(1) performance.
## [param index]: The index of the item to remove (0-based).
func remove_at(index: int) -> void:
	if _is_valid_index(index):
		return
	if index != _items.size() - 1:
		_items[index] = _items.pop_back()
		_items[index].name = str(index)
	else:
		_items.pop_back()


## Returns the index of an item in O(1) time using its name.
## [param item]: The item to find.
## [returns]: The index of the item, or -1 if not found or invalid.
func find(item: Node) -> int:
	if item == null or not item.name.is_valid_int():
		return -1
	var index: int = int(item.name)
	return index if _is_valid_index(index) else -1


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


## Retrieves an item by searching for it in the array.
## [param item]: The item to find.
## [returns]: The item if found, or null if not found.
func get_by_item(item: Node) -> Node:
	var index: int = find(item)
	return get_by_index(index)


## Checks if an index is valid.
## [param index]: The index to check.
## [returns]: True if the index is within bounds, false otherwise.
func _is_valid_index(index: int) -> bool:
	return index >= 0 and index < _items.size()
