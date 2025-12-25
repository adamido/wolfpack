class_name HopNode extends BTreeNode

#Other nodes this node can branch to
@export
var hop_node : BTreeNode

@export
var desire_selector_node : BTreeNode

#Variables for logic within this script
var nav_agent : NavigationAgent2D

var has_target := false
var last_pos : Vector2
var stuck_timer := 0.0
var max_hops := randi_range(2, 6)
var curr_hops := 0


func _ready() -> void:
	parentTreeNode = null
	
func _enter() -> void:
	curr_hops = 0
	max_hops = randi_range(2, 6)
	has_target = false
	#init nav agent and connect to velocity computed signal (Godot requires this signal for NavigationAgent2D to work)
	nav_agent = parentAnimal.nav_agent
	nav_agent.velocity_computed.connect(_on_navigation_agent_2d_velocity_computed)
	#Init our last position so our stuck timer doesn't ever get a null value
	last_pos = parentAnimal.global_position
	parentAnimal.anim.play("hop")
	
func _exit() -> void:
	parentAnimal.velocity = Vector2.ZERO
	nav_agent.velocity_computed.disconnect(_on_navigation_agent_2d_velocity_computed)
	curr_hops = 0

func __unhandled_input(event : InputEvent) -> BTreeNode:
	return null

func __process(delta: float) -> BTreeNode:
	return null
	
func __physics_process(delta: float) -> BTreeNode:

	if curr_hops >= max_hops:
		return desire_selector_node

	#Stuck timer logic
	if parentAnimal.global_position.distance_to(last_pos) < 1.0:
		stuck_timer += delta
	else:
		stuck_timer = 0.0

	if stuck_timer > 1.5:
		print("Rabbit Stuck. Forcing new target")
		stuck_timer = 0.0
		has_target = false
	
	#--MAIN LOGIC--
	if not has_target:
		_set_rand_target()
		has_target = true
		return null
	
	#If we've reached our destination, we start our hop timer and return a reference to ourself
	if nav_agent.is_navigation_finished():
		_start_hop_timer()
		return null
	
	if parentAnimal.can_hop:
		curr_hops+=1
		var next_pos : Vector2 = nav_agent.get_next_path_position()
		var new_velo : Vector2 = (
			parentAnimal.global_position.direction_to(next_pos) * parentAnimal.move_speed
		)
		nav_agent.set_velocity(new_velo)
		
	last_pos = parentAnimal.global_position
	return null
	
#Sets our parentAnimal's nav_agenttarget position to a random position
func _set_rand_target() -> void:
	parentAnimal.nav_agent.target_position = parentAnimal.global_position + Vector2(randf_range(-250, 250), randf_range(-250, 250))

#Built in 
func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	parentAnimal.velocity = safe_velocity
	parentAnimal.move_and_slide()

func _start_hop_timer() -> void:
		#Start the Rabbit's 'hop timer' so our rabbit rests for a moment.
		parentAnimal.can_hop = false
		parentAnimal.hop_timer.start(1.0)
		#Set has_target to false so we get a new target next iteration
		has_target = false	
