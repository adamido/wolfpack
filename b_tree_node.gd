## This class serves as an interface for 'Behavior Nodes' in a 
## Behavior Tree. 
##
## Every BTreeNode has a _setup(animal: Animal) function that gives itself
## a reference to it's parent object, which is an Animal (CharacterBody2D).
## This way, BTreeNodes don't require a specific Node structure in the godot editor.

class_name BTreeNode
extends Node


#Parent 'behavior tree' node, not a godot Node!
@export
var parentTreeNode : BTreeNode 

#Parent 'Node' we will control
var parentAnimal : Animal

func _setup(animal : Animal) -> void:
	self.parentAnimal = animal
	
func _enter() -> void:
	pass
	
func _exit() -> void:
	pass

func __unhandled_input(Event : InputEvent) -> BTreeNode:
	return null

func __process(delta: float) -> BTreeNode:
	return null
	
func __physics_process(delta: float) -> BTreeNode:
	return null
	
