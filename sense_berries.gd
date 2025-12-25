class_name SenseBerries
extends Area2D

func _ready() -> void:
	monitoring = true

func _on_body_entered(body: Node) -> void:
	if body is Berries and body.biomass > 0.0:
		get_parent().register_berry(body)

func _on_body_exited(body: Node) -> void:
	if body is Berries:
		get_parent().unregister_berry(body)
