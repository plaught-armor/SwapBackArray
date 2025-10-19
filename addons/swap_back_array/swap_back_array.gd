class_name SwapBackArray
extends Resource
## Generic array with O(1) removal using swap-back technique.
## Enforces a single type via Variant.Type and supports naming for TYPE_OBJECT.

## Array of items, all of the same type specified by array_type.
var items: Array = []
## Type enforcement for all items (e.g., TYPE_OBJECT, TYPE_INT).
var array_type: Variant.Type = TYPE_NIL


## Initializes the SwapBackArray with type enforcement.
## @param type_of The Variant.Type to enforce (e.g., TYPE_OBJECT).
func _init(type_of: Variant.Type) -> void:
	array_type = type_of


## Appends an item to the array with type enforcement and optional naming.
## @param item The item to append (must match array_type if set).
## @return True if appended, false if type mismatch.
func append(item: Variant) -> bool:
	if array_type != TYPE_NIL and typeof(item) != array_type:
		printerr("Item not of type Variant.Type: %d" % array_type)
		return false
	if array_type == TYPE_OBJECT:
		item.name = str(items.size())
	items.append(item)
	return true


## Removes an item at the specified index using swap-back technique.
## Swaps with last item for O(1) performance and names TYPE_OBJECT items.
## @param index The index of the item to remove (0-based).
func remove(index: int) -> void:
	if index < 0 or index >= items.size():
		return
	var removed_item: Variant = items[index]
	var end: int = items.size() - 1
	if index != end:
		items[index] = items.pop_back()
		if array_type == TYPE_OBJECT:
			items[index].name = str(index)
	items.resize(end)
	if array_type == TYPE_OBJECT:
		removed_item.queue_free()


## Finds the index of an item, using name for TYPE_OBJECT optimization.
## @param item The item to find.
## @return The index of the item, or -1 if not found or type mismatch.
func get_index(item: Variant) -> int:
	if array_type != TYPE_NIL and typeof(item) != array_type:
		return -1
	if array_type == TYPE_OBJECT:
		return int(item.name)
	return items.find(item)


## Returns the current number of items in the array.
## @return The size of the array.
func size() -> int:
	return items.size()


## Clears all items, freeing TYPE_OBJECT instances.
func clear() -> void:
	if array_type == TYPE_OBJECT:
		for item: Variant in items:
			item.queue_free()
	items.clear()


## Retrieves an item by its index with bounds checking.
## @param index The index of the item to retrieve (0-based).
## @return The item at the index, or null if invalid.
func get_by_index(index: int) -> Variant:
	if index < 0 or index >= items.size():
		return null
	return items[index]


## Retrieves an item by searching for it in the array.
## @param item The item to find and retrieve.
## @return The item if found, or null if not found or type mismatch.
func get_by_item(item: Variant) -> Variant:
	var index: int = get_index(item)
	return get_by_index(index)


## Finds the index of an item using linear search (fallback method).
## @param item The item to find.
## @return The index of the item, or -1 if not found.
func find(item: Variant) -> int:
	return items.find(item)
