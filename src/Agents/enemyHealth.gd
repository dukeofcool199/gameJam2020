extends TextureProgress

func _on_KinematicBody2D_value_changed(val):
	value = val

func _on_KinematicBody2D_set_max_value(maximum):
	max_value = maximum
