extends KinematicBody2D

onready var sprite: Sprite = $Minion

const DISTANCE_THRESHOLD: = 3.0

export var max_speed: = 500.0

var target_global_position: = Vector2.ZERO setget set_target_global_position
var _velocity: = Vector2.ZERO

var _is_selected: = false
var _is_moving = false


func _ready() -> void:
	set_physics_process(false)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.get_button_index() == 1:
		if Selection.in_radius(get_global_mouse_position(), global_position):
			_is_selected = true
		elif _is_selected:# and not _is_moving:
			_is_moving = true
			self.target_global_position = get_global_mouse_position()
			_is_selected = false


func _physics_process(delta: float) -> void:
	if Input.is_mouse_button_pressed(1) and not _is_moving:
		self.target_global_position = get_global_mouse_position()
	if global_position.distance_to(target_global_position) < DISTANCE_THRESHOLD:
		stop_moving()
	_velocity = Movement.arrive_to(_velocity,global_position,target_global_position,max_speed)
	_velocity = move_and_slide(_velocity)
	if get_slide_count() > 0:
		stop_moving()
	sprite.rotation = _velocity.angle()
	
func stop_moving() -> void:
	_is_moving = false
	set_physics_process(false)

func set_target_global_position(value: Vector2) -> void:
	target_global_position = value
	set_physics_process(true)
