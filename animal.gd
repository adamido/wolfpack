class_name Animal
extends CharacterBody2D

signal died

@export var stats_template : AnimalStats
var is_dead := false
var stats : AnimalStats
var health :float
var energy :float
var biomass :float
var attack_damage :float
var move_speed :float
var nearby_food :Array[Animal]= []
var nearby_threats:Array[Animal] = []
var target : Node2D

@export var mood_manager : MoodManager

func _ready():
	stats = stats_template.duplicate(true)
	self.health = stats.health
	self.energy = stats.energy
	self.attack_damage = stats.attack_damage
	self.move_speed = stats.move_speed
	self.biomass = stats.biomass

func _eat(a : Animal) -> void:
	#Null check
	if !a or !(a is Animal):
		return
	
	if a.is_dead:
		var gain = a._get_eaten(self)
		var new_energy = self.energy + gain*0.5
		var new_health = self.health + gain*0.2

		#Fat gain is the % of excess health/energy gained.
		var fat_gain = max(0.0, (new_energy - stats.energy) / stats.energy) + max(0.0, (new_health - stats.health) / stats.health)
		if fat_gain > 0.0:
			stats.fat = min(stats.fat + fat_gain, stats.fat_cap)

		self.energy = min(new_energy, stats.energy)
		self.health = min(new_health, stats.health)
		
		return
	
	
func _get_eaten(a : Animal) -> float:

	if biomass <= 0.0:
		return 0.0
	
	var prev_biomass = self.biomass
	var eat_val = a.attack_damage
	self.biomass = max(0.0, self.biomass - eat_val)
	#This logic in the return statement makes sure our 'eater' only gains available biomass, rather than the full attack damage.
	return eat_val + min(0.0, prev_biomass - a.attack_damage)

func _take_damage(amount:float):
	if is_dead:
		return
	self.health -= amount
	if health <= 0.0:
		_die()
	
func _die() -> void:
	if is_dead:
		return
	
	is_dead = true;
	self.biomass = stats.health
	velocity = Vector2.ZERO
	emit_signal("died")

func _get_curr_biomass() -> float:
	return self.biomass

func _add_food(b : Node) -> void:
	if b is Animal:
		self.nearby_food.append(b)

func _remove_food(b : Node) -> void:
	if b is Animal:
		self.nearby_food.erase(b)

func _add_threat(b : Node) ->void:
	pass

func _remove_threat(b : Node) ->void:
	pass

#OVERRIDE This method for new animals!!!
func _is_valid_food(a : Animal) -> bool:
	return false