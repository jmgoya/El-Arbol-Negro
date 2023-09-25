extends CharacterBody2D

const SPEED =300.0
const JUMP_VELOCITY = -500.0
const correr = 1.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var correr_estado = 1
var saltando_estado =  false

func _unhandled_input(event: InputEvent) -> void:
	#Correr
	if event.is_action_pressed("ui_correr"):
		correr_estado = correr
	#si suelto correr vuuelve a 1 para multiplicar
	# 1 * correr
	if event.is_action_released("ui_correr"):
		correr_estado = 1
	var direction = Input.get_axis("ui_left", "ui_right")
	var true_speed = SPEED * correr_estado
	if direction:
		velocity.x = direction * true_speed
	else:
		velocity.x = move_toward(velocity.x, 0, true_speed)
	
	# Handle Jump.
	if Input.is_action_pressed("ui_saltar") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		saltar()
	
	decide_animation()
	# print (velocity.x)

func _physics_process(delta):
	#limite muerte caida
	if position.y >=700:
		print ("Murió")
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
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
