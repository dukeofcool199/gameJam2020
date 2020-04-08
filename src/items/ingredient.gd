extends Area2D



func _on_ingredient_body_entered(body):
	if body.name == "player":
		body.add_ingredient()
		self.get_parent().remove_child(self)

func _process(delta):
	self.rotation += 1 * delta
