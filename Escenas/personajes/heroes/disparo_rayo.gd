extends CharacterBody2D

@export var velocidad:float = 700.0
var direccion: int = 1

func _physics_process(delta):
	velocity =  Vector2(velocidad * direccion,0)
	move_and_slide()
