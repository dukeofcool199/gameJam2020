extends Node2D

onready var timer = $BACKGROUND/Timer
onready var loc = self.get_position_in_parent()
onready var MAX_POSX = 1500 #will set these dynamically or based off parent later
onready var MAX_POSY = 1500
onready var item = preload("res://src/items/ingredient.tscn")

var prev_progress = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.set_wait_time(2)
	timer.start()
	print('timer finished')
	pass # Replace with function body.




func _on_Timer_timeout():
	print(str(self.position))
	print("play area did a timer thing: ")
	var newItem = item.instance()
	newItem.position = Vector2(rand_range(0,MAX_POSX),rand_range(0,MAX_POSY))
	self.get_parent().add_child(newItem)
	
	#Here we will determine if we should spawn enemies.
	# Get the number of collected ingredients
	var progress = self.get_parent().get_node("player").total_collected_ingredients
	# Adjust maybe instead just get current collect ingredients or determine how many until new enemy spawns
	if (self.prev_progress != progress && progress % 7 == 0):
		var newEnemy = load("res://src/Agents/Enemy1.tscn").instance()
		newEnemy.position = Vector2(rand_range(0,MAX_POSX),rand_range(0,MAX_POSY))
		self.get_parent().add_child(newEnemy)
	self.prev_progress = progress
	
	timer.stop()
	timer.set_wait_time(2)
	timer.start()
