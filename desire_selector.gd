class_name DesireSelector extends BTreeNode

var desire : MoodManager.Desires

@export var eat_node : BTreeNode
@export var flee_node : BTreeNode
@export var mate_node : BTreeNode
@export var sleep_node : BTreeNode
@export var wander_node : BTreeNode
@export var desires : Dictionary = {}

func _enter() -> void:
    parentAnimal.velocity = Vector2.ZERO
    desire = parentAnimal.mood_manager._get_curr_desire()
    desires[MoodManager.Desires.EAT] = eat_node
    desires[MoodManager.Desires.FLEE] = flee_node
    desires[MoodManager.Desires.MATE] = mate_node
    desires[MoodManager.Desires.SLEEP] = sleep_node
    desires[MoodManager.Desires.WANDER] = wander_node
    desires[MoodManager.Desires.SLEEP] = sleep_node
    
func _exit() -> void:
    pass

func __process(delta: float) -> BTreeNode:
    return desires.get(desire)