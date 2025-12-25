class_name RabbitFamily
extends Node2D

@export var rabbit_scene : PackedScene
@export var spawn_position : Vector2 = Vector2.ZERO
@export var spawn_on_ready : bool = true

var rabbits : Array[Rabbit] = []

func _ready() -> void:
	for i in range(10):
		if spawn_on_ready:
			rabbits.append(spawn_rabbit())
		

func spawn_rabbit() -> Node2D:
	if rabbit_scene == null:
		push_error("RabbitFamily: rabbit_scene not assigned")
		return null
	
	var rabbit = rabbit_scene.instantiate()
	rabbit.global_position = Vector2(randf_range(-250,250), randf_range(-250,250))
	
	get_tree().current_scene.add_child.call_deferred(rabbit)
	print("Instantiated node type:", rabbit)
	print("Spawned rabbit at: ", rabbit.global_position)
	return rabbit
