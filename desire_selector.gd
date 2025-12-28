class_name DesireSelector extends BTreeNode

var desire : MoodManager.Desires

@export var eat_node : BTreeNode
@export var flee_node : BTreeNode
@export var mate_node : BTreeNode
@export var sleep_node : BTreeNode
@export var wander_node : BTreeNode
var desires : Dictionary


func _enter() -> void:
	var desires = { 
		MoodManager.Desires.EAT : eat_node,
		MoodManager.Desires.FLEE : flee_node,
		MoodManager.Desires.MATE : mate_node,
		MoodManager.Desires.SLEEP : sleep_node,
		MoodManager.Desires.WANDER : wander_node,
	}
	#print("ENTER DESIRE SELECTOR")
	parentAnimal.velocity = Vector2.ZERO
	desire = parentAnimal.mood_manager._get_curr_desire()
	
func _exit() -> void:
	pass

func __process(delta: float) -> BTreeNode:
	match desire:
		MoodManager.Desires.EAT: return eat_node
		MoodManager.Desires.FLEE : return flee_node
		MoodManager.Desires.MATE : return mate_node
		MoodManager.Desires.SLEEP : return sleep_node
		MoodManager.Desires.WANDER : return wander_node

	return null