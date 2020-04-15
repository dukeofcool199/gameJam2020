extends Area2D

onready var player = self.get_parent().find_node("player")
onready var sprite = $Sprite
const BUTTER = 0
const CREAMCHEESE = 1
const CRACKER = 2
var type


func _ready():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	type = rng.randi_range(1, 2)
	print(type)
	if type == self.BUTTER:
		sprite.texture = load("res://assets/tempAssets/butter.png")
		
	elif type == self.CREAMCHEESE:
		sprite.texture = load("res://assets/tempAssets/creamCheese.jpg")
		pass
	
	elif type == self.CRACKER:
		sprite.texture = load("res://assets/tempAssets/grahamCracker.jpg")
		pass

func _on_ingredient_body_entered(body):
	if "goodGuy" in body:
		player.add_ingredient()
		self.get_parent().remove_child(self)

func _process(delta):
	self.rotation += 1 * delta
