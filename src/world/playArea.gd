extends Node2D

onready var timer = $ColorRect/Timer
onready var loc = self.get_position_in_parent()
onready var MAX_POSX = 800 #will set these dynamically or based off parent later
onready var MAX_POSY = 600
onready var item = preload("res://src/items/ingredient.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	timer.set_wait_time(2)
	timer.start()
	print('timer finished')
	pass # Replace with function body.




func _on_Timer_timeout():
	print("play area did a timer thing")
	var newItem = item.instance()
	newItem.position = Vector2(rand_range(0,MAX_POSX),rand_range(0,MAX_POSY))
	self.get_parent().add_child(newItem)
	
	#Here we will determine if we should spawn enemies.
	# Get the number of collected ingredients
	var progress = int(rand_range(0,20)) #self.get_parent().get_node("player").collected_ingredients
	# Adjust maybe instead just get current collect ingredients or determine how many until new enemy spawns
	if ( progress % 5 == 0):
		var newEnemy = load("res://src/Agents/Enemy1.tscn").instance()
		newEnemy.position = Vector2(rand_range(0,MAX_POSX),rand_range(0,MAX_POSY))
		self.get_parent().add_child(newEnemy)
	
	timer.stop()
	timer.set_wait_time(2)
	timer.start()
