extends Node

static func in_radius(
	mouse_position: Vector2,
	global_position: Vector2
) -> bool:
	#print(""+String(mouse_position)+": "+String(global_position))
	if(mouse_position.distance_to(global_position) <= 50):
		return true
	return false
