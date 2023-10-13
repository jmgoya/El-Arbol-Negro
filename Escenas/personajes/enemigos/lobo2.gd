extends CharacterBody2D

const ray_position = 27
const ray_target = 33

@export var danio = 10

var player

var velocidad = 200
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

#Enum de la acciones que reliza este enemigo
@export var acccion := Acciones.Patrullar
enum Acciones { Patrullar, Atacar, muerto}
var estado: int = Acciones.Patrullar
var posicion_heroe: float = 0.0

func _ready():
	iniciar_velocidad()

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
		if $RayParedes.is_colliding():
			morder()
		atacar()
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

func _on_animaciones_animation_finished():
	if $Animaciones.animation == "muerte":
		var tween = create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
		tween.tween_property(self, "scale", Vector2(0,0),Tiempo.velocidad_reloj * 
			Tiempo.delta_tiempo * 30)
		tween.tween_callback(queue_free)
		Eventos.emit_signal("muere_perro", self.global_position)
