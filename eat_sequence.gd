
class_name EatSequence extends BTreeNode

#Child nodes
@export var move_to_target_node : MoveToTarget
@export var eat_node : EatNode
#Breakout if we have no nearby food
@export var wander_seq : BTreeNode

var curr : BTreeNode = null
var children : Array = []
var food_target : Animal
var i:=0

func _ready() -> void:
	children.append(move_to_target_node)
	children.append(eat_node)

func _enter() -> void:
	print("Entered Eat Sequence")
	i = 0
	curr = children[i]
	if curr is MoveToTarget:
		if parentAnimal.nearby_food.size() > 0:
			food_target = parentAnimal.nearby_food.back()
			curr.set_target(food_target)
			curr._enter()
	
func _exit() -> void:
	parentAnimal.velocity = Vector2.ZERO

func __physics_process(delta: float) -> BTreeNode:
	return curr.__physics_process(delta)

func __process(delta: float) -> BTreeNode:
	
	if food_target == null or parentAnimal.nearby_food.size() <= 0:
		return wander_seq

	var res = curr.__process(delta)

	if res == null:
		#curr node is still running
		return null

	if res is FailureNode:
		print("Failed eatSequence")
		curr._exit()
		return wander_seq

	if res is SuccessNode:
		if i+1 < children.size():
			_advance_child()
			return null
		else:
			print("Exiting Eat Sequence")
			curr._exit()
			return wander_seq

	return null


func _advance_child():
	curr._exit()
	i += 1
	curr = children[i]
	if curr is EatNode:
		print("SET EAT TARGET")
		curr.curr_food = food_target
	curr._enter()
