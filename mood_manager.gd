class_name MoodManager extends Node

var parentAnimal : Animal
enum Desires {
	EAT,
	SLEEP,
	WANDER,
	MATE,
	FLEE
}

var desire_vals : Dictionary = {}
var curr_desire : Desires

func _ready() -> void:
	# Initialize the desire values dictionary
	desire_vals = {
		Desires.EAT: 1.0,
		Desires.SLEEP: 0.0,
		Desires.WANDER: 0.0,
		Desires.MATE: 0.0,
		Desires.FLEE: 0.0
	}

#Initialize the MoodManager with a reference to the parent Animal node.
#Unfortunately, you have to use this in your parentAnimal's constructor because our parentAnimal's constructor executes last.
func _init_mood_manager(a: Animal) -> void:
	self.parentAnimal = a

# calc_desires should be called every few seconds based on a timer, not every frame.
func _calc_desires() -> void:
	pass

# returns an enum corresponding with the current desire
func _get_curr_desire() -> Desires:
	var best_score :float= -1.0
	curr_desire = desire_vals[Desires.EAT]
	for d in desire_vals:
		if desire_vals[d] > best_score:
			best_score = desire_vals[d]
			curr_desire = d
			
	return curr_desire
