class_name FindableSwapBackArray
extends SwapBackArray

## A [SwapBackArray] that also supports O(1) find(item)/get_by_item via an
## instance-id -> index side table. Pays one hash op per mutation to keep the
## table current; prefer the base [SwapBackArray] when you only remove by index.
var _index_of: Dictionary[int, int] = {}


## Appends an item and records its index in the side table.
## [param item]: The Node to append.
func append(item: Node) -> void:
	if item == null:
		return
	_index_of[item.get_instance_id()] = _items.size()
	_items.append(item)


## Removes an item at the specified index using swap-back, updating the side table.
## [param index]: The index of the item to remove (0-based).
func remove_at(index: int) -> void:
	if not _is_valid_index(index):
		return
	var removed_id: int = _items[index].get_instance_id()
	var last: int = _items.size() - 1
	if index != last:
		var moved: Node = _items[last]
		_items[index] = moved
		_index_of[moved.get_instance_id()] = index
	_items.resize(last)
	_index_of.erase(removed_id)


## Clears all items and the side table.
func clear() -> void:
	super()
	_index_of.clear()


## Returns the index of an item in O(1) time.
## [param item]: The item to find.
## [returns]: The index of the item, or -1 if not found.
func find(item: Node) -> int:
	if item == null:
		return -1
	var index: int = _index_of.get(item.get_instance_id(), -1)
	return index if _is_valid_index(index) and _items[index] == item else -1


## Retrieves an item by searching for it in the array.
## [param item]: The item to find.
## [returns]: The item if found, or null if not found.
func get_by_item(item: Node) -> Node:
	return get_by_index(find(item))
