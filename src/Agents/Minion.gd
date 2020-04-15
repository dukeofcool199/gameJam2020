extends KinematicBody2D

onready var sprite: Sprite = $Minion
onready var player = get_parent().get_node("player")

const DISTANCE_THRESHOLD: = 3.0
const PLAYER_DISTANCE_THRESHOLD: = 100.0

const goodGuy = 0

export var max_speed: = 150.0

var target_global_position: = Vector2.ZERO setget set_target_global_position
var _velocity: = Vector2.ZERO
var distance_threshold: = DISTANCE_THRESHOLD
var health: = 100

var _is_selected: = false
var _is_moving = false

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.get_button_index() == 1:
		if Selection.in_radius(get_global_mouse_position(), global_position):
			_is_selected = true
		elif _is_selected:# and not _is_moving:
			start_moving()

func _physics_process(delta: float) -> void:
	if get_parent().game_over:
		set_physics_process(false)
	if Input.is_mouse_button_pressed(1) and _is_selected and not _is_moving:
		self.target_global_position = get_global_mouse_position()
	elif not _is_moving:
		follow_player()
	if global_position.distance_to(self.target_global_position) < self.distance_threshold:
		stop_moving()
		# Due actions here
		#Go Back to following Big Cheese
		follow_player()
		
	else:
		_velocity = Movement.arrive_to(_velocity,global_position,target_global_position,max_speed)
		_velocity = move_and_slide(_velocity)
		if get_slide_count() > 0:
			var object = get_slide_collision(0).collider
			if object != null and not object.has_method("i_am_minion"):
				stop_moving()
			# I collided with something
			# If enemy I might need to flee or attack
			# If friendly I need to do other actions.
		sprite.rotation = _velocity.angle()
	
	#MINION WALKING ANIMATION
	var thresh = 50
	if _velocity.x < 0-thresh and _velocity.y < 0 or _velocity.x < 0-thresh and _velocity.y > 0 or _velocity.x < 0-thresh:
		$MIN_ANIM.play("A_KEY")
	elif _velocity.x > thresh and _velocity.y < 0 or _velocity.x > thresh and _velocity.y > 0 or _velocity.x > thresh:
		$MIN_ANIM.play("D_KEY")
	elif _velocity.y > 0:
		$MIN_ANIM.play("S_KEY")
	elif _velocity.y < 0:
		$MIN_ANIM.play("W_KEY")

func start_moving() -> void:
	_is_moving = true
	self.distance_threshold = DISTANCE_THRESHOLD
	self.target_global_position = get_global_mouse_position()
	_is_selected = false

func stop_moving() -> void:
	_is_moving = false

func follow_player() -> void:
	if player != null and global_position.distance_to(player.global_position) > PLAYER_DISTANCE_THRESHOLD:
		self.target_global_position = player.global_position
		self.distance_threshold = PLAYER_DISTANCE_THRESHOLD
		set_physics_process(true)

func set_target_global_position(value: Vector2) -> void:
	target_global_position = value
	set_physics_process(true)

func i_am_minion():
	return true	

func take_damage(amount: int) -> void:
	self.health -= amount
	if(self.health <= 0):
		die()

func die() -> void:
	get_tree().get_root().remove_child(self)
	self.call_deferred("free")
