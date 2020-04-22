extends Area2D

onready var player = self.get_parent().find_node("player")
onready var sprite = $Sprite
const BUTTER = 0
const CREAMCHEESE = 1
const CRACKER = 2
var type
onready var rng = RandomNumberGenerator.new()


func _ready():

	rng.randomize()
	type = rng.randi_range(0, 2)
	print(type)
	if type == self.BUTTER:
		sprite.texture = load("res://assets/tempAssets/INGREDIENTS/BUTTER.png")
		
	elif type == self.CREAMCHEESE:
		sprite.texture = load("res://assets/tempAssets/INGREDIENTS/CREAMCHEESE.png")
		pass
	
	elif type == self.CRACKER:
		sprite.texture = load("res://assets/tempAssets/INGREDIENTS/GRAHAM.png")
		pass

func _on_ingredient_body_entered(body):
	if self == null or body == null:
		return
	if "goodGuy" in body:
		player.add_ingredient(self.type)
		self.get_parent().remove_child(self)
	elif "badGuy" in body:
		self.get_parent().get_child(body.get_index()).wait = 1
		if self != null:
			self.get_parent().remove_child(self)

func _process(delta):
	self.rotation += 1 * delta
