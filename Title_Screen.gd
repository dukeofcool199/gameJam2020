extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$MarginContainer/HBoxContainer/TextureButton2.grab_focus()

func _physics_process(delta):
	if $MarginContainer/HBoxContainer/TextureButton2.is_hovered() == true:
		$MarginContainer/HBoxContainer/TextureButton2.grab_focus()
	if $MarginContainer/HBoxContainer/TextureButton.is_hovered() == true:
		$MarginContainer/HBoxContainer/TextureButton.grab_focus()
		


func _on_TextureButton2_pressed():
	get_tree().change_scene("res://src/Game.tscn")


func _on_TextureButton_pressed():
	get_tree().change_scene("res://Instruction_Screen.tscn")
