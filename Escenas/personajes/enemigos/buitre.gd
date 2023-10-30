extends CharacterBody2D

var nido = Vector2(0.0,0.0)

var aceleracion = 50.0
var vuelo = false
var velocidad = Vector2()
var objetivo
var destino = Vector2(0,0)

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	vuelo = false



func _physics_process(delta):
	
	if volar :
		if position.distance_to(destino) > 200:
			move_and_slide()
		else:
			if objetivo:
				velocity = Vector2(0,0)
			else:
				descansar()
		if objetivo :
			volar( Vector2(objetivo.global_position.x +10 ,objetivo.global_position.y -60))
		elif position.distance_to(nido) != 0:
			volar(nido)
			print (nido)
	
	# Add the gravity.
	if !is_on_floor() && !vuelo:
		velocity.y += gravity * (delta /2)
	elif is_on_floor() && not nido:
		nido = self.global_position
		
	move_and_slide()

func volar(pos: Vector2):
	destino = pos
	vuelo = true
	if objetivo:
		$radar.scale = Vector2(1.5, 1.5)
	if position.x > destino.x:
		$Animaciones.flip_h = false
	else:
		$Animaciones.flip_h = true
		
	$Animaciones.play("vuela")
	velocity = position.direction_to(destino) * aceleracion
	

func _on_area_cuerpo_area_entered(area):
		if area.name == "bala":
			velocity.x = 0
			$Animaciones.play("muerte")
			self.set_collision_layer_value(1, false)


func _on_radar_body_entered(body):
	objetivo = body
	volar(Vector2(objetivo.global_position.x +1 ,objetivo.global_position.y -60))

func _on_radar_body_exited(body):
	objetivo = null
	$radar.scale =Vector2(1.0, 1.0)
	volar (nido)

func atacar():
	$Animaciones.play("ataca")

func descansar():
	$Animaciones.play("idle")
	vuelo = false
	
	
