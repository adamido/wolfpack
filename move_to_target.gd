
class_name MoveToTarget extends BTreeNode

@export var fail_node : FailureNode
@export var success_node : SuccessNode

var stuck_timer := 0.0
const MAX_STUCK_TIME = 1.5

var target : Node2D
var last_pos :Vector2

func _enter() -> void:
	if parentAnimal.nav_agent != null:
		#Set Nav Agent's target
		parentAnimal.nav_agent.velocity_computed.connect(_on_navigation_agent_2d_velocity_computed)
		parentAnimal.nav_agent.target_position = target.global_position
		last_pos = parentAnimal.global_position

		#Get next path position from NavAgent, and assign velocity
		var next_pos : Vector2 = parentAnimal.nav_agent.get_next_path_position()
		var new_velo : Vector2 = (
			parentAnimal.global_position.direction_to(next_pos) * parentAnimal.move_speed
		)
		#print("Path size:", parentAnimal.nav_agent.get_current_navigation_path().size())
		parentAnimal.nav_agent.set_velocity(new_velo)

	stuck_timer = 0

func _exit() -> void: 
	#If parentAnimal's navigation agent is not null, we must disconnect signals
	if parentAnimal.nav_agent != null:
		if parentAnimal.nav_agent.velocity_computed.is_connected(_on_navigation_agent_2d_velocity_computed):
			parentAnimal.nav_agent.velocity_computed.disconnect(_on_navigation_agent_2d_velocity_computed)

	parentAnimal.velocity = Vector2.ZERO

func __process(delta: float) -> BTreeNode:

	if parentAnimal.nav_agent == null: 
		print("ERROR in move_to_target.gd: Parent Animal's navigation agent is null.")
		return fail_node

	if stuck_timer >= MAX_STUCK_TIME:
		return fail_node

	if parentAnimal.nav_agent.is_navigation_finished():	
		return success_node
	return null
	

func __physics_process(delta: float) -> BTreeNode:

	if parentAnimal.nav_agent == null: 
		print("ERROR in move_to_target.gd: Parent Animal's navigation agent is null.")
		return fail_node

	if parentAnimal.global_position.distance_to(last_pos) < 1.5:
		stuck_timer+=delta
	else: 
		stuck_timer = 0

	#if stuck_timer >= MAX_STUCK_TIME:
		#print("UNSTUCK RABBIT")
		#return fail_node


	var next_pos : Vector2 = parentAnimal.nav_agent.get_next_path_position()
	var new_velo : Vector2 = (
		parentAnimal.global_position.direction_to(next_pos) * parentAnimal.move_speed
	)
	parentAnimal.nav_agent.set_velocity(new_velo)	

	last_pos = parentAnimal.global_position

	#DEBUGGING 
	#if parentAnimal.nav_agent.get_current_navigation_path().size() > 0:
		#print("Current path size:", parentAnimal.nav_agent.get_current_navigation_path().size())

	return null


#This is a required function for NavigationAgent2D to apply movement physics to our body
func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	parentAnimal.velocity = safe_velocity
	parentAnimal.move_and_slide()

func set_target(t : Node2D):
	target = t
