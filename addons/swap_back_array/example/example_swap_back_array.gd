extends Node3D
## Demonstrates SwapBackArray usage with spawning and removing Node3D instances.

## Scene to spawn (e.g., a simple Node3D with a mesh).
@export var spawn_scene: PackedScene
## Maximum number of instances to spawn.
@export var max_instances: int = 5
## Random spawn radius around the node.
@export var spawn_radius: float = 2.0

## Manages spawned instances.
var array: SwapBackArray = SwapBackArray.new(TYPE_OBJECT)
## Timer for periodic spawning/removal.
var timer: float = 0.0


func _ready() -> void:
	assert(spawn_scene, "spawn scene missing")


func _process(delta: float) -> void:
	timer += delta
	if timer >= 1.0:
		timer = 0.0
		if array.size() < max_instances:
			spawn_instance()
		else:
			remove_random_instance()


## Spawns a new instance at a random position.
func spawn_instance() -> void:
	var instance: Node3D = spawn_scene.instantiate()
	get_tree().root.add_child(instance)
	var rand_angle: float = randf() * TAU
	var rand_dist: float = randf() * spawn_radius
	instance.global_position = global_position + Vector3(cos(rand_angle) * rand_dist, 0, sin(rand_angle) * rand_dist)
	if not array.append(instance):
		instance.queue_free()


## Removes a random instance from the array.
func remove_random_instance() -> void:
	if array.size() > 0:
		array.remove(randi() % array.size())
