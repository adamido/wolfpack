class_name DeathNode extends BTreeNode

func _enter() -> void:
	parentAnimal.velocity = Vector2.ZERO
	parentAnimal.move_and_slide()
	parentAnimal.anim.play("dead")
	
