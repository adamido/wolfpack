## Defines a collection of variables needed for every 'Animal' in our sim
class_name AnimalStats extends Resource

var level := 1

#Base Stats
@export var health :float= 1.0
@export var energy :float= 1.0
@export var attack_damage :float= .25
@export var move_speed :float= 100.0
@export var fat :float= 0.0
@export var fat_cap :float= 1.0
#Biomass determines how much 'food' this animal is worth if it dies
@export var biomass :float= 1.0

#'Personality' Stats
@export var intelligence :float= .5
@export var courage :float= .5
@export var lust :float= .5

#