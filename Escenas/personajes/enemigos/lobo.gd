extends CharacterBody2D


const SPEED =300.0
const JUMP_VELOCITY = -500.0
const correr = 1.5


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var trepar = false
var correr_estado = 1
var saltando_estado =  false



func _physics_process(delta):
	#limite muerte caida
	if position.y >=700:
		print ("Murió")
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		### que al saltar pueda subir a una plataforma
#		if (velocity.y < 1):
#			$CollisionShape2D.disabled = true
#		else:
#			$CollisionShape2D.disabled = false
	else: 
		saltando_estado = false
#
	move_and_slide()
#
func saltar():
	if saltando_estado == true:
		return
	else:
		saltando_estado = true
	$Animaciones.play("salto")

#carga las animaciones de acuerdo al movimiento
func decide_animation():
	
	if saltando_estado :
		return
		
	var velocidad = velocity.x
	match velocidad:
		0.0:
			#idle
			if  is_on_floor():
				$Animaciones.play("idle")
		SPEED:
			#derecha
			$Animaciones.flip_h = false
			if  is_on_floor():
				$Animaciones.play("caminar")
		SPEED * correr:
			#correr derecha
			$Animaciones.flip_h = false
			if  is_on_floor():
				$Animaciones.play("run")
		-SPEED:
			#izquierda
			$Animaciones.flip_h = true
			if  is_on_floor():
				$Animaciones.play("caminar")
		-(SPEED * correr):
			#correr izquierda
			$Animaciones.flip_h = true
			if  is_on_floor():
				$Animaciones.play("run")
		_:
			pass



func _on_animaciones_animation_finished():
	saltando_estado = false
	$Animaciones.play("idle")


func _on_area_2d_area_entered(area):
	var nombre = area.get_name()
	print (nombre)
	if nombre == "soga":
		trepar = true


func _on_area_2d_area_exited(area):
	var nombre = area.get_name()
	print (nombre)
	if nombre == "soga":
		trepar = false
