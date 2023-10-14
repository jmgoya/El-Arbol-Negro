extends CharacterBody2D

@export var velocidad:float = 700.0
@export var duracion_máxima:int = 30
var direccion: int = 1
var duracion:int = 0

func _physics_process(delta):
	if duracion == duracion_máxima:
		queue_free()
	else:
		duracion = duracion + 1
	velocity =  Vector2(velocidad * direccion,0)
	move_and_slide()



func _on_bala_body_entered(body):
	#choca y desaparece
	queue_free()


