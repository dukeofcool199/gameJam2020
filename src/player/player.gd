extends KinematicBody2D 
const MOVE_SPEED = 300
 
onready var raycast = $RayCast2D
onready var camera: Camera2D = $Camera2D
onready var anim_player: AnimationPlayer = $AnimationPlayer
onready var sprite: = $Cheesecake_Ani

onready var minion = preload("res://src/Agents/Minion.tscn")

#ingredient inventories
var butter = 0
var creameCheese = 0
var crackers = 0

signal value_changed(val)
signal set_max_value(maximum)
const goodGuy = 0

var health: = 1000
 
func _ready():
	yield(get_tree(), "idle_frame")
	camera.set_as_toplevel(true)
	camera.global_position = global_position
	emit_signal("set_max_value", self.health)
	emit_signal("value_changed", self.health)
 
func _physics_process(delta):
	var move_vec = Vector2()
	if Input.is_action_pressed("move_up"):
		move_vec.y -= 1
		$Cheesecake_Ani.play("RUN_W")
	if Input.is_action_pressed("move_down"):
		move_vec.y += 1
		$Cheesecake_Ani.play("RUN_S")
	if Input.is_action_pressed("move_left"):
		move_vec.x -= 1
		$Cheesecake_Ani.play("RUN_A")
	if Input.is_action_pressed("move_right"):
		move_vec.x += 1
		$Cheesecake_Ani.play("RUN_D")
		
	move_vec = move_vec.normalized()
	move_and_collide(move_vec * MOVE_SPEED * delta)
   
	var look_vec = get_global_mouse_position() - global_position
	sprite.global_rotation = atan2(look_vec.y, look_vec.x)
	camera.global_position = global_position
	
func _process(delta):
	if Input.is_action_just_pressed("spawn_minion") and self.creameCheese > 0 and self.butter > 0 and self.crackers > 0:
		get_parent().add_child(minion.instance())
		self.butter -= 1
		self.creameCheese -= 1
		self.crackers -= 1
	
func i_am_minion():
	pass	

func take_damage(amount: int) -> void:
	self.health -= amount
	emit_signal("value_changed", self.health)
	if(self.health <= 0):
		die()
		
func add_ingredient(type) -> void:
	match type:
		0:
			self.butter += 1
		1:
			self.creameCheese += 1
		2:
			self.crackers += 1
			
	print("butter: "+str(self.butter))
	print("cheese: "+str(self.creameCheese))
	print("crackers: "+str(self.crackers))
	#$RichTextLabel.add_text("self.ingredients")

func die() -> void:
	#Have the end screen here
	get_parent().game_over = true
	set_physics_process(false)
	global_rotation = atan2(0,0)
	anim_player.play("fade_in")
	return
