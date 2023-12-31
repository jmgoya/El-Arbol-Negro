extends CharacterBody2D

const ray_position = 27
const ray_target = 33

@export var danio:float = 1.00

var player

var velocidad = 200
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

#Enum de la acciones que reliza este enemigo
@export var acccion := Acciones.Patrullar
enum Acciones { Patrullar, Atacar, muerto, Morder}
var estado: int = Acciones.Patrullar
var posicion_heroe: float = 0.0

func _ready():
	Eventos.tiempo.connect(vision)
	iniciar_velocidad()
	

func vision(dia, hora, cielo):
	
	if (hora >=9 and hora <= 18 ):
		$radar/CollisionRadar.scale = Vector2 (1.0, 1.0)
	else:
		$radar/CollisionRadar.scale = Vector2 (0.5, 0.5)

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
	elif estado == Acciones.Morder:
		morder()
		
	move_and_slide()

func morder():
	Eventos.emit_signal("mordiendo", danio)

func _on_radar_body_entered(body):
	if body.name == "Heroe" and estado != Acciones.muerto:
		player = body
		estado = Acciones.Atacar


func atacar():
	if global_position.x < player.position.x - 5:
		velocity.x = abs(velocity.x)
		direccion()
	elif global_position.x > player.position.x +5:
		velocity.x = abs(velocity.x) * -1
		direccion()
	else:
		pass

func _on_radar_body_exited(body):
	if body.name == "Heroe" and estado != Acciones.muerto:
		player = null
		estado = Acciones.Patrullar
		iniciar_velocidad()

func direccion():
	if velocity.x > 0:
		$RayParedes.target_position.x = ray_target
		$RayPiso.position.x = ray_position
		$Animaciones.flip_h = false
	else:
		$RayParedes.target_position.x = -ray_target
		$RayPiso.position.x = -ray_position
		$Animaciones.flip_h = true

func iniciar_velocidad():
	velocidad = randi() % 80 + 30
	$RayParedes.target_position.x = ray_target
	$RayPiso.position.x = ray_position
	if (randi () %2 + 1) >=2 :
		velocity.x = -velocidad
	else:
		velocity.x = velocidad
	$Animaciones.play("correr")
	direccion()

func _on_area_cuerpo_area_entered(area):
	if area.name == "bala":
		estado = Acciones.muerto
		velocity.x = 0
		$Animaciones.play("muerte")
		self.set_collision_layer_value(1, false)
		$radar.set_collision_mask_value(2,false)

func _on_animaciones_animation_finished():
	if $Animaciones.animation == "muerte":
		var tween = create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
		tween.tween_property(self, "scale", Vector2(0,0),Tiempo.velocidad_reloj / 
			Tiempo.delta_tiempo * 2)
		Eventos.emit_signal("muere_perro", self.global_position )
		tween.tween_callback(queue_free)


func _on_area_cuerpo_body_entered(body):
	if body.name == "Heroe" and estado != Acciones.muerto:
		estado = Acciones.Morder
		morder()
		


func _on_area_cuerpo_body_exited(body):
	if body.name == "Heroe" and estado != Acciones.muerto:
		player = body
		estado = Acciones.Atacar
