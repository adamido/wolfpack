class_name EatNode extends BTreeNode

@export var success_node : SuccessNode
@export var fail_node : FailureNode
var curr_food : Animal

const EAT_RANGE := 100.0
const EAT_TIME := 1.0
var eat_timer := 0.0
    
func _enter() -> void:
    print("Entered eat node")

func __process(delta: float) -> BTreeNode:
    if curr_food == null or curr_food.biomass <= 0.0:
        print("Food null. Cannot Eat")
        return fail_node

    if (parentAnimal._is_valid_food(curr_food) and eat_timer <= 0.0):
        parentAnimal._eat(curr_food)
        eat_timer = EAT_TIME
        return null
    elif curr_food == null or curr_food._get_curr_biomass() <= 0.0:
        parentAnimal._remove_food(curr_food)
        return success_node
    
    eat_timer -= delta
    return null

