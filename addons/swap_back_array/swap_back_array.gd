class_name SwapBackArray
extends Resource
## Generic array with O(1) removal using swap-back technique.
## Enforces a single type via Variant.Type and supports naming for TYPE_OBJECT.

## Array of items, all of the same type specified by array_type.
var items: Array = []
## Type enforcement for all items (e.g., TYPE_OBJECT, TYPE_INT).
var array_type: Variant.Type = TYPE_NIL


## Initializes the SwapBackArray with type enforcement.[br]
## [param type_of] is the Variant.Type to enforce (e.g., TYPE_OBJECT).[br]
## [b]Example[/b]:
## [codeblock]
## var array: SwapBackArray = SwapBackArray.new(TYPE_OBJECT)
## [/codeblock]
func _init(type_of: Variant.Type) -> void:
	array_type = type_of


## Appends an item to the array with type enforcement and optional naming.[br]
## [param item] The data to append (must match [param array_type]).[br][br]
## [b]Returns[/b]: True if appended, false if type mismatch.[br][br]
## [b]Example[/b]:
## [codeblock]
## var array: SwapBackArray = SwapBackArray.new(TYPE_OBJECT)
## var node: Node3D = Node3D.new()
## array.append(node)  # Adds node, names it "0"
## [/codeblock]
func append(item: Variant) -> bool:
	if array_type != TYPE_NIL and typeof(item) != array_type:
		printerr("Item not of type Variant.Type: %d" % array_type)
		return false
	if array_type == TYPE_OBJECT:
		item.name = str(items.size())
	items.append(item)
	return true


## Removes an item at the specified index using swap-back technique.[br]
## Swaps with the last item for O(1) performance and names TYPE_OBJECT items.[br]
## [param index] The Index of the item to remove (0-based).[br][br]
## [b]Example[/b]:
## [codeblock]
## var array: SwapBackArray = SwapBackArray.new(TYPE_OBJECT)
## var node: Node3D = Node3D.new()
## array.append(node)
## array.remove(0)  # Removes node, frees it
## [/codeblock]
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


## Finds the index of an item, using name for TYPE_OBJECT optimization.[br]
## [param item] The item to find.[br][br]
## [b]Returns[/b]: The index of the item, or -1 if not found or type mismatch.[br][br]
## [b]Example[/b]:
## [codeblock]
## var array: SwapBackArray = SwapBackArray.new(TYPE_OBJECT)
## var node: Node3D = Node3D.new()
## array.append(node)
## print(array.get_index(node))  # Prints: 0
## [/codeblock]
func get_index(item: Variant) -> int:
	if array_type != TYPE_NIL and typeof(item) != array_type:
		return -1
	if array_type == TYPE_OBJECT:
		return int(item.name)
	return items.find(item)


## Returns the current number of items in the array.[br][br]
## [b]Returns[/b]: The size of the array.[br][br]
## [b]Example[/b]:
## [codeblock]
## var array: SwapBackArray = SwapBackArray.new(TYPE_INT)
## array.append(42)
## print(array.size())  # Prints: 1
## [/codeblock]
func size() -> int:
	return items.size()


## Clears all items, freeing TYPE_OBJECT instances.[br][br]
## [b]Example[/b]:
## [codeblock]
## var array = SwapBackArray.new(TYPE_OBJECT)
## var node = Node3D.new()
## array.append(node)
## array.clear()  # Frees node and empties array
## [/codeblock]
func clear() -> void:
	if array_type == TYPE_OBJECT:
		for item: Variant in items:
			item.queue_free()
	items.clear()


## Retrieves an item by its index with bounds checking.[br]
## [param index] The index of the item to retrieve (0-based).[br][br]
## [b]Returns[/b]: The item at the index, or null if invalid.[br][br]
## [b]Example[/b]:
## [codeblock]
## var array = SwapBackArray.new()
## array.append(42)
## print(array.get_by_index(0))  # Prints: 42
## [/codeblock]
func get_by_index(index: int) -> Variant:
	if index < 0 or index >= items.size():
		return null
	return items[index]


## Retrieves an item by searching for it in the array.[br]
## [param item] The item to find and retrieve.[br][br]
## [b]Returns[/b]: The item if found, or null if not found or type mismatch.[br][br]
## [b]Example[/b]:
## [codeblock]
## var array = SwapBackArray.new()
## array.append(42)
## print(array.get_by_item(42))  # Prints: 42
## [/codeblock]
func get_by_item(item: Variant) -> Variant:
	var index: int = get_index(item)
	return get_by_index(index)


## Finds the index of an item using linear search (fallback method).[br]
## [param item] The item to find.[br][br]
## [b]Returns[/b]: The index of the item, or -1 if not found.[br][br]
## [b]Example[/b]:
## [codeblock]
## var array = SwapBackArray.new()
## array.append(42)
## print(array.find(42))  # Prints: 0
## [/codeblock]
func find(item: Variant) -> int:
	return items.find(item)
