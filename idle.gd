##An 'Idle' node for 'behavior_tree.gd'.

## Idle node will wait for a few seconds, defined by a float variable, 'time'
## Idle node will return a SuccessNode upon depleting it's timer

class_name Idle extends BTreeNode

var time = 1.0

func _enter() -> void:
    parentAnimal.velocity = Vector2.ZERO


func _process(delta: float) -> void:
    if time > 0:
        time -= delta
    else: return SuccessNode.new()