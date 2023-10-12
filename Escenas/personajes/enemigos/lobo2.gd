extends CharacterBody2D

var velocidad = 200
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	velocidad = randi() % 80 + 30
	if (randi () %2 + 1) >=2 :
		velocity.x = -velocidad
		self.scale.x *= -1
	else:
		velocity.x = velocidad
	$Animaciones.play("correr")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if !$RayPiso.is_colliding() || $RayParedes.is_colliding():
		self.scale.x *= -1
		velocity.x *= -1
	move_and_slide()
	
