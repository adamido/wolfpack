class_name Rabbit
extends Animal


#IM USING A RESOURCE NOW BUT WHATEVER
const RABBIT_SPEED :float= 100
const RABBIT_MAX_HEALTH :float= .25
const RABBIT_MAX_ENERGY :float= .25
const RABBIT_ATTACK_DAMAGE :float= .25

#A rabbit's energy will decrease by this much every second.
const RABBIT_STARVE_SPEED :float= .05

#Navigation agent used for pathfinding
@export
var nav_agent : NavigationAgent2D
#Target for our behavior tree to navigate to

@export
var b_tree : BehaviorTree
#Conditionals used in our behavior tree nodes
var hop_timer : Timer
var can_hop := true


@export 
var anim : AnimatedSprite2D


func _ready() -> void:

	nearby_food = []
	
	#Init Rabbit's stat variables
	stats = stats_template.duplicate(true)
	self.health = stats.health
	self.energy = stats.energy
	self.attack_damage = stats.attack_damage
	self.move_speed = stats.move_speed

	#Connect hop timer
	hop_timer = get_node("HopTimer")
	hop_timer.timeout.connect(_on_timer_timeout)
	print("Rabbit.gd DEBUG: Rabbit ready at: ", global_position)
	print("Rabbit health: ", self.health)

	#Init this Rabbit's MoodManager
	mood_manager._init_mood_manager(self)

func _process(delta: float) -> void:
	b_tree.__process(delta)
	
func _physics_process(delta: float) -> void:
	
	#BAREBONE STARVATION MECHANICS. TODO: We should consider fat, and other factors.
	if self.energy > 0:
		self.energy -= RABBIT_STARVE_SPEED * delta
	elif energy <= 0:
		health -= RABBIT_STARVE_SPEED * delta

	#die() if health is below 0
	if health <= 0 and !is_dead:
		_die()

	#TODO: Corpse decay, right now a Rabbit must be eaten to be removed from the world.
	if is_dead and self.biomass <= 0:
		#Remove rabbit from world
		queue_free()
	
	b_tree.__physics_process(delta)

func _unhandled_input(event: InputEvent) -> void:
	b_tree._unhandled_input(event)

func _on_timer_timeout():
	can_hop = true

func register_berry(berry: Berries) -> void:
	if not nearby_food.has(berry):
		nearby_food.append(berry)
		print("Rabbit.gd DEBUG: Berry sensed at: ", berry.global_position)

func unregister_berry(berry: Berries) -> void:
	nearby_food.erase(berry)
	#print("Rabbit.gd DEBUG: Berry removed. Berry exists?", nearby_food.has(berry))

func _eat(a : Animal) -> void:

	if !a or a.biomass <= 0.0:
		return
	
	if a is Berries:

		var gain = a._get_eaten(self)
		var new_energy = self.energy + gain*0.5
		var new_health = self.health + gain*0.2
		print("Rabbit ate! ", a)
		#Fat gain is the % of excess health/energy gained.
		var fat_gain = max(0.0, (new_energy - stats.energy) / stats.energy) + max(0.0, (new_health - stats.health) / stats.health)
		if fat_gain > 0.0:
			stats.fat = min(stats.fat + fat_gain, stats.fat_cap)

		self.energy = min(new_energy, stats.energy)
		self.health = min(new_health, stats.health)
		
	else:
		print("Rabbit failed to EAT!")
	pass

func _is_valid_food(a : Animal) -> bool:
	return a is Berries and a.biomass > 0
