class_name WanderSequence
extends BTreeNode

@export var move_to_target_node : BTreeNode
@export var idle_node : BTreeNode
var children : Array = []
var i := 0
var max_hops := 3
var curr_hops := 0

@export var rand_point : Marker2D

func _enter() -> void:
    rand_point.global_position = parentAnimal.global_position + _get_rand_point(300)
    children.clear()
    children.append(move_to_target_node)
    children.append(idle_node)
    i = 0

    curr_hops = 0
    parentAnimal.target = rand_point

func __process(delta: float) -> BTreeNode:
    var curr = children[i]
    var res = curr.__process(delta)

    if res == null:
        # Still running
        return curr

    if res is FailureNode:
        return parentTreeNode

    if res is SuccessNode:
        i += 1
        if i >= children.size():
            curr_hops += 1
            if curr_hops < max_hops:
                # Start next hop
                i = 0
                rand_point.global_position = parentAnimal.global_position + _get_rand_point(300)
                parentAnimal.target = rand_point
            else:
                # Finished wandering
                return parentTreeNode

    return curr

func _get_rand_point(r: float) -> Vector2:
    return Vector2(randf_range(-r, r), randf_range(-r, r))
