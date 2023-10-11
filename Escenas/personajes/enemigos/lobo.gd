extends CharacterBody2D


const SPEED = 10
const JUMP_VELOCITY = -500.0
const correr = 1.5

#Enum de la acciones que reliza este enemigo
@export var acccion := Acciones.Patrullar
enum Acciones { Patrullar, Atacar, muerto}

var estado: int = Acciones.Patrullar

var velocidad_inicial = randi() % 60 - 30

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var trepar = false
var correr_estado = 1
var saltando_estado =  false

#para el movimiento
var posicion = Vector2(10,20)

func _ready():
	velocity.x = velocidad_inicial
	move_and_slide()


func _physics_process(delta):
	if estado == Acciones.muerto:
		return
	#limite muerte caida
	if position.y >=700:
		muere()
	if velocity.x == 0:
		if $Animaciones.flip_h == false:
			velocity.x = -SPEED
		else:
			velocity.x = SPEED
	#patruya
	if !test_move(Transform2D(0,Vector2(position.x + (velocity.x / 2), position.y)), Vector2(0,1)):
		#print ("va a caer")
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
	if estado == Acciones.muerto:
		return
	
	if saltando_estado :
		return
		
	var velocidad = velocity.x
	
	if velocidad > 0 :
			#derecha
			$Animaciones.flip_h = false
			if  is_on_floor():
				$Animaciones.play("run")
	elif velocidad < 0:
			#izquierda
			$Animaciones.flip_h = true
			if  is_on_floor():
				$Animaciones.play("run")
	else:
		pass

func _on_animaciones_animation_finished():
	if $Animaciones.animation == "muerte":
		print ("animando la muerte")
		var tween = create_tween()
		tween.tween_property(self, "scale", Vector2(0,0), 10)
		tween.tween_callback(self.queue_free)


func _on_area_2d_area_entered(area):
	var nombre = area.get_name()
	if nombre == "soga":
		trepar = true
	elif  nombre == "bala":
		muere()

func muere():
	estado = Acciones.muerto
	velocity.x = 0
	$Animaciones.play("muerte")
	Eventos.emit_signal("muere_perro")

func _on_area_2d_area_exited(area):
	var nombre = area.get_name()
	if nombre == "soga":
		trepar = false
