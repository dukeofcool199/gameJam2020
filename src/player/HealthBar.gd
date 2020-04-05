extends TextureProgress

func _on_player_set_max_value(maximum: int):
	max_value = maximum

func _on_player_value_changed(val: int):
	value = val
