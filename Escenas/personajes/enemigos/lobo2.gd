extends CharacterBody2D


const ray_position = 27
const ray_target = 33

var velocidad = 200
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

#Enum de la acciones que reliza este enemigo
@export var acccion := Acciones.Patrullar
enum Acciones { Patrullar, Atacar, muerto}
var estado: int = Acciones.Patrullar
var posicion_heroe: float = 0.0

func _ready():
	velocidad = randi() % 80 + 30
	$RayParedes.target_position.x = ray_target
	$RayPiso.position.x = ray_position
	if (randi () %2 + 1) >=2 :
		velocity.x = -velocidad
		$RayParedes.target_position.x *= -1
		$RayPiso.position.x *= -1
		$Animaciones.flip_h = true
	else:
		velocity.x = velocidad
	$Animaciones.play("correr")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if estado == Acciones.Patrullar:
		if (!$RayPiso.is_colliding() || $RayParedes.is_colliding() ) :
			velocity.x *= -1
			$RayParedes.target_position.x *= -1
			$RayPiso.position.x *= -1
			$Animaciones.flip_h = not $Animaciones.flip_h
	elif estado == Acciones.Atacar:
		atacar()
	move_and_slide()

func _on_radar_body_entered(body):
#	if body.name == "Heroe":
#		estado = Acciones.Atacar
#		posicion_heroe = body.position.x
	pass

func atacar():
	if global_position.x < posicion_heroe:
		velocity.x = abs(velocity.x)
		self.scale.x = -1
	elif global_position.x > posicion_heroe:
		velocity.x = abs(velocity.x) * -1
		self.scale.x = 1
	else:
		velocity.x = 0
	


func _on_radar_body_exited(body):
	if body.name == "Heroe":
		estado = Acciones.Patrullar
