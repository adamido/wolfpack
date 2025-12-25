class_name DeathNode extends BTreeNode

func _enter() -> void:
	parentAnimal.velocity = Vector2.ZERO
	parentAnimal.anim.play("dead")
	
