extends Area2D

var parentAnimal : Animal

func _ready() -> void:  
    monitoring = true
    parentAnimal = self.get_parent()

func _on_body_entered(body: Node) -> void:
    if body is Animal:
        if body.biomass > 0.0:
            parentAnimal._add_food(body)
            #print("Registered Food: ", body)

func _on_body_exited(body: Node) -> void:
    if body is Animal:
        get_parent()._remove_food(body)
        #print("Food Left: ", body)
