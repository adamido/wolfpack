class_name BerryPatch extends Node2D

@export var berries_scene : PackedScene
@export var r_width : float = 500
@export var r_height : float = 500

func _ready() -> void:
	for i in range(10):
		spawn_berries()

func spawn_berries() -> Node2D:
	if berries_scene == null:
		push_error("BerryPatch: berries_scene not assigned")
		return null
	
	var berries = berries_scene.instantiate()
	berries.global_position = Vector2(randf_range(-r_width, r_width), randf_range(-r_height, r_height))
	
	get_tree().current_scene.add_child.call_deferred(berries)
	#print("Instantiated node type: ", berries)
	#print("Spawned berries at: ", berries.global_position)
	return berries
