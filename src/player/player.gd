extends KinematicBody2D 
const MOVE_SPEED = 300
 
onready var raycast = $RayCast2D
onready var camera: Camera2D = $Camera2D
onready var anim_player: AnimationPlayer = $AnimationPlayer
onready var sprite: = $Cheesecake_Ani

enum DIR {up,down,left,right}
var currentDir = DIR.up

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
	var speed = 1
	var move_vec = Vector2()

	if Input.is_action_pressed("move_up"):
		move_vec.y -= speed
		currentDir = DIR.up
		if Input.is_action_pressed("move_right"):
			$Cheesecake_Ani.play("RUN_D")
		elif Input.is_action_pressed("move_left"):
			$Cheesecake_Ani.play("RUN_A")
		else:
			$Cheesecake_Ani.play("RUN_W")
	if Input.is_action_pressed("move_down"):
		currentDir = DIR.down
		move_vec.y += speed
		if Input.is_action_pressed("move_right"):
			$Cheesecake_Ani.play("RUN_D")
		elif Input.is_action_pressed("move_left"):
			$Cheesecake_Ani.play("RUN_A")
		else:
			$Cheesecake_Ani.play("RUN_S")
	if Input.is_action_pressed("move_left"):
		currentDir = DIR.left
		move_vec.x -= speed
		$Cheesecake_Ani.play("RUN_A")
	if Input.is_action_pressed("move_right"):
		currentDir = DIR.right
		move_vec.x += speed
		$Cheesecake_Ani.play("RUN_D")
	if move_vec.x == 0 && move_vec.y == 0:
		$Cheesecake_Ani.play("IDLE")
		
	if Input.is_action_just_released("idle"):
		$Cheesecake_Ani.play("IDLE")

		
	move_vec = move_vec.normalized()
	move_and_collide(move_vec * MOVE_SPEED * delta)
	camera.global_position = global_position
	
func _process(delta):
	if Input.is_action_pressed("spawn_minion") and self.creameCheese > 0 and self.butter > 0 and self.crackers > 0:
		
		var posOffset = 50
		var pos = self.position
		var newMinion = minion.instance()
		match currentDir:
			DIR.up:
				newMinion.position = Vector2(pos.x,pos.y+posOffset)
			DIR.down:
				newMinion.position = Vector2(pos.x,pos.y-posOffset)
			DIR.left:
				newMinion.position = Vector2(pos.x+posOffset,pos.y)
			DIR.right:
				newMinion.position = Vector2(pos.x-posOffset,pos.y)
				

		get_parent().add_child(newMinion)
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
