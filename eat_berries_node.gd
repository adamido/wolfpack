class_name EatBerriesNode extends BTreeNode

var nav_agent : NavigationAgent2D
var target : Animal

@export
var hop_node : BTreeNode

var last_pos : Vector2
var stuck_timer := 0.0
const EAT_RANGE := 100.0

const EAT_TIME := 1.0
var eat_timer := 0.0

func _ready() ->void:
	parentTreeNode = null

func _exit() -> void:
	_clear_target()
	parentAnimal.velocity = Vector2.ZERO
	nav_agent.velocity_computed.disconnect(_on_navigation_agent_2d_velocity_computed)

func _enter() -> void:

	parentAnimal.velocity = Vector2.ZERO
	
	nav_agent = parentAnimal.nav_agent
	nav_agent.velocity_computed.connect(_on_navigation_agent_2d_velocity_computed)
	
	if parentAnimal is Rabbit: 
		if parentAnimal.nearby_food.size() > 0:
			target = parentAnimal.nearby_food.back()
			#Actually set nav_agent target!!
			nav_agent.target_position = target.global_position

	last_pos = parentAnimal.global_position

func __process(delta: float) -> BTreeNode:

	if target == null and parentAnimal.nearby_food.size() > 0:
		_clear_target()
		target = parentAnimal.nearby_food.back()
		nav_agent.target_position = target.global_position

	if target == null:
		_clear_target()
		return hop_node

	if target.biomass <= 0.0:
		parentAnimal._remove_food(target)
		parentAnimal.nearby_food.erase(target)
		_clear_target()
		return hop_node

	if eat_timer < EAT_TIME:
		eat_timer += delta
	elif parentAnimal.global_position.distance_to(target.global_position) <= EAT_RANGE:
		eat_timer = 0
		parentAnimal._eat(target)

	return null

func __physics_process(delta: float) -> BTreeNode:

	#If we don't have a target we gonna go back to random hopping
	if target == null:
		_clear_target()
		return hop_node

	if target.biomass <= 0.0:
		parentAnimal._remove_food(target)
		parentAnimal.nearby_food.erase(target)
		_clear_target()
		return hop_node

	#Stuck timer logic  
	if target == null and parentAnimal.global_position.distance_to(last_pos) < 2.5:
		stuck_timer += delta
	else:
		stuck_timer = 0.0

	if stuck_timer > 1.5:
		print("Rabbit Stuck. Forcing new target from eat berries ")
		_clear_target()
		return hop_node


	var next_pos : Vector2 = nav_agent.get_next_path_position()
	var new_velo : Vector2 = (
		parentAnimal.global_position.direction_to(next_pos) * parentAnimal.move_speed
	)
	nav_agent.set_velocity(new_velo)

	last_pos = parentAnimal.global_position
	return null

func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	parentAnimal.velocity = safe_velocity
	parentAnimal.move_and_slide()  

func _clear_target():
	target = null
	eat_timer = 0.0
	stuck_timer = 0.0
