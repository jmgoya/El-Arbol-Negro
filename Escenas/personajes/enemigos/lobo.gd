extends CharacterBody2D


const SPEED = 10
const JUMP_VELOCITY = -500.0
const correr = 1.5

#Enum de la acciones que reliza este enemigo
@export var acccion := Acciones.Patrullar
enum Acciones { Patrullar, Atacar, muerto}

var estado: int = Acciones.Patrullar
var posicion_heroe = Vector2 (0,0)
var velocidad_inicial

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var trepar = false
var correr_estado = 1
var saltando_estado =  false

#para el movimiento
var posicion = Vector2(10,20)

func _ready():
	var d = randi() % 2 + 1
	velocidad_inicial = randi() % 40 + 20
	print (d)
	if (d > 0):
		velocidad_inicial = velocidad_inicial * -1
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
			velocity.x = -velocidad_inicial
		else:
			velocity.x = velocidad_inicial
	
	#verifica las acciones
	if estado == Acciones.Patrullar:
		patruyar()
	elif estado == Acciones.muerto:
		pass
	
		
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	decide_animation()
	move_and_slide()

func atacar(posicion):
	print (posicion.x )
	print (self.position.x)
	if posicion.x >= self.position.x + 1 :
		velocity.x = abs(velocity.x) 
	else:
		velocity.x = abs(velocity.x)  * -1


func patruyar():
	#patruya
	if !test_move(Transform2D(0,Vector2(position.x + (velocity.x / 2), position.y)), Vector2(0,1)): 
		#verifica si va a caer
		velocity.x = velocity.x * (-1)

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
		var tween = create_tween()
		tween.tween_property(self, "scale", Vector2(0,0), 10)
		tween.tween_callback(self.queue_free)


func _on_area_2d_area_entered(area):
	var nombre = area.get_name()
	if nombre == "bala":
		muere()
	elif nombre == "Heroe":
		print ("morder)")

func muere():
	estado = Acciones.muerto
	velocity.x = 0
	$radar/CollisionRadar.queue_free()
	$Area2D/CollisioArea.queue_free()
	$CollisionLobo.queue_free()
	$Animaciones.play("muerte")
	Eventos.emit_signal("muere_perro")

func _on_area_2d_area_exited(area):
	var nombre = area.get_name()
	if nombre == "soga":
		trepar = false

func _on_radar_body_entered(body):
	if body.name == "Heroe":
		estado = Acciones.Atacar
		atacar(body.position)

func _on_radar_body_exited(body):
	if estado != Acciones.muerto:
		estado= Acciones.Patrullar
