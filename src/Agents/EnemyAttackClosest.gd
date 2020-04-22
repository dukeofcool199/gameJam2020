extends KinematicBody2D

onready var sprite: Sprite = $Enemy1

onready var player = get_parent().get_node("player")


onready var MAX_POSX = 800 #will set these dynamically or based off parent later
onready var MAX_POSY = 600

const DISTANCE_THRESHOLD: = 3.0

export var max_speed: = 100.0

var target_global_position: = Vector2.ZERO setget set_target_global_position
var _velocity: = Vector2.ZERO
var away_dist = 100
var badGuy = 0
var wait = 0

var random_count = 0

var type = 2 
# 0: attack closest, 
# 1: attack Big cheese, 
# 2: stay right from closest
# 3: stay left from closest
# 4: stay up from closest
# 5: stay down from closest
# 6: Move randomly
# 7: Eat Closest ingredient

var activeAnims
onready var worker1Anims = {"sleep":"W1_SLEEP","left":"W1_LEFT","right":"W1_RIGHT"}
onready var worker2Anims = {"sleep":"W2_SLEEP","left":"W2_LEFT","right":"W2_RIGHT"}
onready var worker3Anims = {"sleep":"W3_SLEEP","left":"W3_LEFT","right":"W3_RIGHT"}
onready var rng = RandomNumberGenerator.new()

const WONE = 0
const WTWO = 1
const WTHREE = 2


var function_dict = { close = funcref(self, "attack_closest"), 
big_cheese = funcref(self, "attack_player"), 
right = funcref(self, "stay_right"), 
left = funcref(self, "stay_left"), 
up = funcref(self, "stay_up"), 
down = funcref(self, "stay_down"), 
rand = funcref(self, "move_random"), 
ingreds = funcref(self, "closest_ingredient")}

func _ready():
	self.type = int(rand_range(0,56)) % 8
	rng.randomize()
	type = rng.randi_range(0, 2)
	print(type)
	if type == self.WONE:
		activeAnims = worker1Anims
		
	elif type == self.WTWO:
		activeAnims = worker2Anims
	
	elif type == self.WTHREE:
		activeAnims = worker3Anims

func _physics_process(delta: float) -> void:
	if get_parent().game_over:
		set_physics_process(false)
		return
	self.target_global_position = find_target_position()
	if global_position.distance_to(target_global_position) < DISTANCE_THRESHOLD:
		return
	if get_slide_count() > 0:
			var object = get_slide_collision(0).collider
			if object != null and object.has_method("i_am_minion"):
				$ENEMYANIM.play(activeAnims["sleep"])
				object.take_damage(100)
				sleep(1)
	if wait == 1:
		sleep(wait)
		wait = 0
		return
	_velocity = Movement.arrive_to(_velocity,global_position,target_global_position,max_speed)
	_velocity = move_and_slide(_velocity)
	sprite.rotation = _velocity.angle()
	
	#ENEMY WALKING ANIMATION
	var thresh = 50
	if _velocity.x < 0-thresh and _velocity.y < 0 or _velocity.x < 0-thresh and _velocity.y > 0 or _velocity.x < 0-thresh:
		$ENEMYANIM.play(activeAnims["right"])
	elif _velocity.x > thresh and _velocity.y < 0 or _velocity.x > thresh and _velocity.y > 0 or _velocity.x > thresh:
		$ENEMYANIM.play(activeAnims["left"])

func sleep(time: int) -> void:
	set_physics_process(false)
	yield(get_tree().create_timer(time), "timeout")
	set_physics_process(true)

func set_target_global_position(value: Vector2) -> void:
	target_global_position = value
	set_physics_process(true)

# This attacks closest PC
func find_target_position() -> Vector2:
	var dict_values = function_dict.keys()
	return function_dict[dict_values[type]].call_func()

func attack_closest() -> Vector2:
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

func attack_player() -> Vector2:
	if player != null:
		return player.global_position
	return global_position

func stay_right() -> Vector2:
	return attack_closest() + Vector2(away_dist,0)

func stay_left() -> Vector2:
	return attack_closest() + Vector2(-away_dist,0)

func stay_up() -> Vector2:
	return attack_closest() + Vector2(0,-away_dist)

func stay_down() -> Vector2:
	return attack_closest() + Vector2(0,away_dist)

func move_random() -> Vector2:
	if random_count < 100:
		random_count += 1
		return self.target_global_position
	else:
		random_count = 0
		return Vector2(rand_range(0, self.MAX_POSX),rand_range(0, self.MAX_POSY))

func closest_ingredient() -> Vector2:
	var actors = get_parent().get_children()
	var close_distance = INF
	var close_actor = null
	for actor in actors:
		if actor.has_method("_on_ingredient_body_entered"):
			var temp_dist = global_position.distance_to(actor.global_position)
			if close_distance > temp_dist:
				close_distance = temp_dist
				close_actor = actor
	if close_actor != null:
		return close_actor.global_position
	return global_position
