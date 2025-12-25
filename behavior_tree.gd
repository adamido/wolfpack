class_name BehaviorTree

extends Node

@export 
var starting_tree_node : BTreeNode
@export 
var death_node : BTreeNode

var curr_tree_node : BTreeNode

var parent : Animal

# VERY IMPORTANT: Provides child nodes with a reference to the parent animal!
func _ready() -> void:
	_init_tree(self, self.get_parent())
	
	parent = self.get_parent()
	change_node(starting_tree_node)

#Recursively call _init_tree on all children of the given node. This is necessary for the child nodes to have a pointer to the parent animal.
func _init_tree(node: Node, animal : Animal) -> void:
	for c in node.get_children():
		if c is BTreeNode:
			c._setup(animal)
		_init_tree(c, animal)
		

#Change to a new behavior node
func change_node(new_node : BTreeNode) -> void:
	if curr_tree_node:
		curr_tree_node._exit()
		
	curr_tree_node = new_node
	curr_tree_node._enter()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func __process(delta: float) -> void:
	#Check if parent Animal is dead
	if parent.get("is_dead"):
		if curr_tree_node != death_node:
			change_node(death_node)
		return
		
	var new_tree_node = curr_tree_node.__process(delta)
	if new_tree_node:
		change_node(new_tree_node)
		
func __physics_process(delta: float) -> void:
	#Check if parent Animal is dead
	if parent.get("is_dead"):
		if curr_tree_node != death_node:
			change_node(death_node)
			return
	
	var new_tree_node = curr_tree_node.__physics_process(delta)
	if new_tree_node:
		change_node(new_tree_node)
		
func _unhandled_input(event: InputEvent) -> void:
	var new_tree_node = curr_tree_node.__unhandled_input(event)
	if new_tree_node:
		change_node(new_tree_node)
