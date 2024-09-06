extends Camera2D

var Cat : CharacterBody2D

func _ready():
	Cat = get_parent().get_node("Mraw")

func _physics_process(delta):
	
	position += (Cat.position - position)
	position = position.clamp(Vector2(400, 100), Vector2(750, 430))
