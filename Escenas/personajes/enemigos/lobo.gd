extends CharacterBody2D


const SPEED =30.0
const JUMP_VELOCITY = -500.0
const correr = 1.5

#Enum de la acciones que reliza este enemigo
@export var acccion := Acciones.Patrullar
enum Acciones { Patrullar, Atacar}

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var trepar = false
var correr_estado = 1
var saltando_estado =  false

#para el movimiento
var posicion = Vector2(10,20)

func _ready():
	velocity.x = SPEED
	move_and_slide()


func _physics_process(delta):
	#limite muerte caida
	if position.y >=700:
		print ("Murió")
	
	#patruya
	if !test_move(Transform2D(0,Vector2(position.x + velocity.x, position.y)), Vector2(0,1)):
		print ("va a caer")
		velocity.x = velocity.x * (-1)
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		### que al saltar pueda subir a una plataforma
#		if (velocity.y < 1):
#			$CollisionShape2D.disabled = true
#		else:
#			$CollisionShape2D.disabled = false
#	else: 
#		saltando_estado = false
	decide_animation()
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
				$Animaciones.play("run")
		SPEED * correr:
			#correr derecha
			$Animaciones.flip_h = false
			if  is_on_floor():
				$Animaciones.play("run")
		-SPEED:
			#izquierda
			$Animaciones.flip_h = true
			if  is_on_floor():
				$Animaciones.play("run")
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
