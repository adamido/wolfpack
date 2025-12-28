## This class defines the Wander Sequence Node which randomly
## directs an animal. 
 
class_name WanderSequence
extends BTreeNode

@export var WANDER_RADIUS = 125.0
@export var move_to_target_node : BTreeNode
@export var idle_node : BTreeNode
var children : Array = []
var i := 0
var max_hops := 3
var curr_hops := 0
#Reference to our currently executing node
var curr : BTreeNode = null

#Marker to navigate to
@export var rand_point : Marker2D

func _ready() -> void:
	#Populate array of children
	children.append(move_to_target_node)
	children.append(idle_node)	


func _enter() -> void:
	#calculate a random point to move towards.
	rand_point.global_position = parentAnimal.global_position + _get_rand_point(WANDER_RADIUS)

	#assign curr and execute _enter().
	i = 0
	curr = children[0]
	if curr is MoveToTarget:
		curr.set_target(rand_point)
	curr._enter()

	curr_hops = 0

func _exit() -> void:
	parentAnimal.velocity = Vector2.ZERO

func __physics_process(delta: float) -> BTreeNode:
	return curr.__physics_process(delta)

func __process(delta: float) -> BTreeNode:
	var res = curr.__process(delta)

	if res == null:
		# Still running
		return null

	if res is FailureNode:
		print("FAILNODE!")
		curr._exit()
		return parentTreeNode

	if res is SuccessNode:
		if i+1 < children.size():
			_advance_child()
			return null
		else:
			print("EXITING WANDER SEQUENCE")
			curr._exit()
			return parentTreeNode

	return null


func _get_rand_point(r: float) -> Vector2:
	return Vector2(randf_range(-r, r), randf_range(-r, r))

func _advance_child():
	curr._exit()
	i += 1
	curr = children[i]
	curr._enter()
