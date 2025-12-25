class_name Berries
extends Animal

const BERRIES_MAX_HEALTH = .25
const BERRIES_MAX_ENERGY = .25
const BERRIES_MAX_BIOMASS = .25

var death_timer : Timer
@export
var sprite : AnimatedSprite2D

enum States{
	ALIVE,
	DEAD
}

var curr_state : States

func _ready() -> void:
	self.health = BERRIES_MAX_HEALTH
	self.energy = BERRIES_MAX_ENERGY
	self.biomass = BERRIES_MAX_BIOMASS
	self.curr_state = States.ALIVE
	death_timer = get_node("DeathTimer")

func _physics_process(delta: float) -> void:
	pass
	
func _process(delta: float) -> void:
	
	curr_state = States.ALIVE if self.biomass > 0.0 else States.DEAD
	match curr_state:
		States.ALIVE:
			sprite.play("alive")
			self.health += .005
			self.energy += .005
			pass
		States.DEAD:
			sprite.play("dead")
			death_timer.start(150)


func _on_death_timer_timeout() -> void:
	if curr_state == States.DEAD:
		self.health = BERRIES_MAX_HEALTH
		self.energy = BERRIES_MAX_ENERGY
		self.biomass = BERRIES_MAX_BIOMASS
		curr_state == States.ALIVE
