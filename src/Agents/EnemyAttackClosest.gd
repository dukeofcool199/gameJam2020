extends KinematicBody2D

onready var sprite: Sprite = $Enemy1

onready var player = get_parent().get_node("player")

const DISTANCE_THRESHOLD: = 3.0

export var max_speed: = 100.0

var target_global_position: = Vector2.ZERO setget set_target_global_position
var _velocity: = Vector2.ZERO

func _physics_process(delta: float) -> void:
	if get_parent().game_over:
		set_physics_process(false)
		return
	self.target_global_position = find_target_position()
	if global_position.distance_to(target_global_position) < DISTANCE_THRESHOLD:
		stop_moving()
	if get_slide_count() > 0:
			var object = get_slide_collision(0).collider
			if object != null and object.has_method("i_am_minion"):
				$ENEMYANIM.play("SLEEP")
				object.take_damage(100)
				set_physics_process(false)
				yield(get_tree().create_timer(1), "timeout")
				set_physics_process(true)
	$ENEMYANIM.play("WALKR")
	_velocity = Movement.arrive_to(_velocity,global_position,target_global_position,max_speed)
	_velocity = move_and_slide(_velocity)
	sprite.rotation = _velocity.angle()
	
func stop_moving() -> void:
	set_physics_process(false)

func set_target_global_position(value: Vector2) -> void:
	target_global_position = value
	set_physics_process(true)

# This attacks closest PC
func find_target_position() -> Vector2:
	var actors = get_parent().get_children()
	var close_distance = INF
	var close_actor = null
	for actor in actors:
		if actor.has_method("i_am_minion"):
			var temp_dist = global_position.distance_to(actor.global_position)
			if close_distance > temp_dist:
				close_distance = temp_dist
				close_actor = actor
	if close_actor != null:
		return close_actor.global_position
	return global_position
