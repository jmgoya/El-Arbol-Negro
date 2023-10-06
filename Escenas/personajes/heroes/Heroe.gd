extends CharacterBody2D

@export var disparos: PackedScene

const SPEED =300.0
const JUMP_VELOCITY = -500.0
const correr = 1.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var trepar = false
var correr_estado = 1
var saltando_estado =  false
var poder_luz = Vector2(0.7,0.7)
var disparando  =false

func _unhandled_input(event: InputEvent) -> void:
	
	if event.is_action_released("ui_disparo"):
		$Animaciones.play("idle")
	
	#enciende la luz
	if event.is_action_pressed("ui_cancel"):
		if $Luz.global_scale == poder_luz  :
			var tween_luz = create_tween()
			tween_luz.tween_property($Luz, "global_scale",Vector2(0,0), 1,)
			
		else:
			var tween_luz = create_tween()
			tween_luz.tween_property($Luz, "global_scale",poder_luz, 1,)
	
		
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
	
	if trepar:
		print ("Trepar")
		direction = Input.get_axis("ui_up", "ui_down")
		velocity.y = direction * SPEED / 2
	
	# Handle Jump.
	if Input.is_action_pressed("ui_saltar") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		saltar()
	#Dispara
	if event.is_action_pressed("ui_disparo"):
		Disparar()
	
	decide_animation()
	# print (velocity.x)

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

func Disparar():
	disparando = true
	print ("Disparando")
	var bala = disparos.instantiate()
	bala.global_position = $spawn_disparo.global_position
	get_parent().add_child(bala)
	if $Animaciones.flip_h == true:
		bala.set("direccion",-1)
	else:
		bala.set("direccion",1)
	$Animaciones.play("ataque1")

#carga las animaciones de acuerdo al movimiento
func decide_animation():
	if saltando_estado or disparando:
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
			$spawn_disparo.position.x = 35
			if  is_on_floor():
				$Animaciones.play("caminar")
		SPEED * correr:
			#correr derecha
			$Animaciones.flip_h = false
			$spawn_disparo.position.x = 35
			if  is_on_floor():
				$Animaciones.play("run")
		-SPEED:
			#izquierda
			$Animaciones.flip_h = true
			$spawn_disparo.position.x = -35
			if  is_on_floor():
				$Animaciones.play("caminar")
		-(SPEED * correr):
			#correr izquierda
			$Animaciones.flip_h = true
			$spawn_disparo.position.x = -35
			if  is_on_floor():
				$Animaciones.play("run")
		_:
			pass



func _on_animaciones_animation_finished():
	if saltando_estado ==  true:
		saltando_estado = false
		$Animaciones.play("idle")
	if disparando ==  true:
		disparando = false
		$Animaciones.play("idle")

func _on_area_2d_area_entered(area):
	var nombre = area.get_name()
	print (nombre)
	if "soga" in nombre:
		trepar = true


func _on_area_2d_area_exited(area):
	var nombre = area.get_name()
	print (nombre)
	if "soga" in nombre:
		trepar = false
