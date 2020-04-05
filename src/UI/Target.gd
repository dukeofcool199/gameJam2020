extends Area2D

onready var anim_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	connect("body_entered", self, "_on_body_entered")
	visible = false

func _input(event: InputEvent):
	if event is InputEventMouseButton and event.get_button_index() == 1 and not get_parent().game_over:
		anim_player.play("fade_in")
		global_position = get_global_mouse_position()

func _on_body_entered(body: PhysicsBody2D) -> void:
	anim_player.play("fade_out")
