
class_name MoveToTarget extends BTreeNode

@export var fail_node := FailureNode.new()
@export var success_node := SuccessNode.new()

var stuck_timer := 0.0
const MAX_STUCK_TIME = 1.5

var last_pos :Vector2

func _enter() -> void:
	last_pos = parentAnimal.global_position
	parentAnimal.nav_agent.velocity_computed.connect(_on_navigation_agent_2d_velocity_computed)
	#Initialize nav_agent's target position
	parentAnimal.nav_agent.target_position = parentAnimal.target

func _exit() -> void:
	parentAnimal.nav_agent.velocity_computed.disconnect(_on_navigation_agent_2d_velocity_computed)
	parentAnimal.target = null

func __physics_process(delta: float) -> BTreeNode:

	if parentAnimal.distance_to(last_pos) < 1.5:
		stuck_timer+=delta
	else: 
		stuck_timer = 0

	if stuck_timer >= MAX_STUCK_TIME:
		return fail_node

	if parentAnimal.nav_agent.is_navigation_finished():	
		return success_node

	var next_pos : Vector2 = parentAnimal.nav_agent.get_next_path_position()
	var new_velo : Vector2 = (
		parentAnimal.global_position.direction_to(next_pos) * parentAnimal.move_speed
	)
	parentAnimal.nav_agent.set_velocity(new_velo)	

	last_pos = parentAnimal.global_position

	return null


#Built in 
func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	parentAnimal.velocity = safe_velocity
	parentAnimal.move_and_slide()