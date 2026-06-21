class_name SwapBackUtil
extends RefCounted

## O(1) swap-back removal helpers for Packed*Array value types.
##
## GDScript has no generics, so one function exists per packed type. Each removes
## the element at [param index] in O(1) by overwriting it with the last element
## and shrinking the array by one — order is NOT preserved.
##
## Packed arrays are passed by reference here (verified: in-place mutation is
## visible to the caller and does not trigger a copy), so these mutate the array
## you pass and return nothing. Use for plain data (ids, positions, scalars);
## for Nodes with identity lookup use [SwapBackArray] / [FindableSwapBackArray].
##
## [codeblock]
## var ids: PackedInt32Array = [10, 20, 30, 40]
## SwapBackUtil.remove_at_i32(ids, 1) # ids == [10, 40, 30]
## [/codeblock]
##
## This class is static-only — never instantiate it.


static func remove_at_byte(arr: PackedByteArray, index: int) -> void:
	var last: int = arr.size() - 1
	if index < 0 or index > last:
		return
	if index != last:
		arr[index] = arr[last]
	arr.resize(last)


static func remove_at_i32(arr: PackedInt32Array, index: int) -> void:
	var last: int = arr.size() - 1
	if index < 0 or index > last:
		return
	if index != last:
		arr[index] = arr[last]
	arr.resize(last)


static func remove_at_i64(arr: PackedInt64Array, index: int) -> void:
	var last: int = arr.size() - 1
	if index < 0 or index > last:
		return
	if index != last:
		arr[index] = arr[last]
	arr.resize(last)


static func remove_at_f32(arr: PackedFloat32Array, index: int) -> void:
	var last: int = arr.size() - 1
	if index < 0 or index > last:
		return
	if index != last:
		arr[index] = arr[last]
	arr.resize(last)


static func remove_at_f64(arr: PackedFloat64Array, index: int) -> void:
	var last: int = arr.size() - 1
	if index < 0 or index > last:
		return
	if index != last:
		arr[index] = arr[last]
	arr.resize(last)


static func remove_at_str(arr: PackedStringArray, index: int) -> void:
	var last: int = arr.size() - 1
	if index < 0 or index > last:
		return
	if index != last:
		arr[index] = arr[last]
	arr.resize(last)


static func remove_at_v2(arr: PackedVector2Array, index: int) -> void:
	var last: int = arr.size() - 1
	if index < 0 or index > last:
		return
	if index != last:
		arr[index] = arr[last]
	arr.resize(last)


static func remove_at_v3(arr: PackedVector3Array, index: int) -> void:
	var last: int = arr.size() - 1
	if index < 0 or index > last:
		return
	if index != last:
		arr[index] = arr[last]
	arr.resize(last)


static func remove_at_v4(arr: PackedVector4Array, index: int) -> void:
	var last: int = arr.size() - 1
	if index < 0 or index > last:
		return
	if index != last:
		arr[index] = arr[last]
	arr.resize(last)


static func remove_at_color(arr: PackedColorArray, index: int) -> void:
	var last: int = arr.size() - 1
	if index < 0 or index > last:
		return
	if index != last:
		arr[index] = arr[last]
	arr.resize(last)
