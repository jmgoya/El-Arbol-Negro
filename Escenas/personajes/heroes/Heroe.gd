extends CharacterBody2D

@export var disparos: PackedScene

const SPEED =300.0
const JUMP_VELOCITY = -500.0
const correr = 1.5

@export var salud = 100.00
@export var sabiduria = 50.0
@export var experiencia = 4.0
@export var fuerza = 50.0
@export var fuerza_max = 60.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var trepar = false
var correr_estado = 1
var saltando_estado =  false
var disparando  =false

func _ready():
	Eventos.mordiendo.connect(recive_danio)
	actualizar_valores("todo", 0)

func recive_danio(danio: float):
	salud -= (danio / 10)
	actualizar_valores("salud", salud)

func actualizar_valores(propiedad, valor):
	if propiedad == "salud" or propiedad =="todo":
		Eventos.emit_signal("valores_player", "salud", salud)
	if propiedad == "fuerza" or propiedad =="todo":
		Eventos.emit_signal("valores_player", "fuerza", fuerza)

func _unhandled_input(event: InputEvent) -> void:
	#enciende la luz
	if event.is_action_pressed("ui_cancel"):
		Eventos.emit_signal("luz")
		
	#Correr
	if event.is_action_pressed("ui_correr"):
		correr_estado = correr
	#si suelto correr vuuelve a 1 para multiplicar
	# 1 * correr
	if event.is_action_released("ui_correr"):
		correr_estado = 1
	var direction = Input.get_axis("ui_left", "ui_right")
	var true_speed = SPEED * correr_estado
		#limite izquierdo
	if direction:
		velocity.x = direction * true_speed
	else:
		velocity.x = move_toward(velocity.x, 0, true_speed)
	if trepar:
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

func _physics_process(delta):
	decide_animation()
	#limite muerte caida
	if position.y >=700:
		get_tree().reload_current_scene()
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	else: 
		saltando_estado = false
	move_and_slide()

func saltar():
	if saltando_estado == true:
		return
	else:
		saltando_estado = true
	$Animaciones.play("salto")

func Disparar():
	disparando = true
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
	if disparando ==  true:
		disparando = false
	$Animaciones.play("idle")

func _on_area_2d_area_entered(area):
	var nombre = area.get_name()
	if "soga" in nombre:
		trepar = true
	if "hongo_area" in nombre:
		print ("que coma el hongo")

func _on_area_2d_area_exited(area):
	var nombre = area.get_name()
	if "soga" in nombre:
		trepar = false
