extends Node2D

onready var timer = $ColorRect/Timer
onready var loc = self.get_position_in_parent()
onready var MAX_POS = self.scale.x
onready var item = preload("res://src/items/ingredient.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	timer.set_wait_time(2)
	timer.start()
	print('timer finished')
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print(timer.time_left)


func _on_Timer_timeout():
	print("play area did a timer thing")
	var newItem = item.instance()
	newItem.position.x = 20
	self.get_parent().add_child(newItem)
	
	timer.stop()
	timer.set_wait_time(5)
	timer.start()