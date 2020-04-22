extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$MarginContainer/HBoxContainer/TextureButton.grab_focus()

func _physics_process(delta):
	if $MarginContainer/HBoxContainer/TextureButton.is_hovered() == true:
		$MarginContainer/HBoxContainer/TextureButton.grab_focus()

func _on_TextureButton_pressed():
	get_tree().change_scene("res://src/Game.tscn")
