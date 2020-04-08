extends Area2D

onready var player = self.get_parent().find_node("player")


func _on_ingredient_body_entered(body):
	if "goodGuy" in body:
		player.add_ingredient()
		self.get_parent().remove_child(self)

func _process(delta):
	self.rotation += 1 * delta
