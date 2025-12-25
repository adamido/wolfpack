class_name NoseArea extends Area2D


func _ready() -> void:
	self.set_collision_layer_value(1, false)
	self.set_collision_mask_value(2, true)
	self.monitoring = true
	
	
