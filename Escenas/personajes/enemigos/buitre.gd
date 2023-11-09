extends CharacterBody2D

@onready var agente = $NavigationAgent2D


var nido = Vector2(0.0,0.0)
var danio = 1.0
var aceleracion = 80.0
var velocidad = Vector2()
var objetivo
var destino = Vector2(0,0)
enum estados_buitre {descansa, vuela, ataca, regresa, muerto}
var estado_buitre

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	estado_buitre = estados_buitre.descansa
#	nido = Vector2 (self.global_position.x , self.global_position.y - 20)
#	destino = nido
#
#func establecer_nido():
#	nido = Vector2 (self.global_position.x , self.global_position.y - 20)
#	destino = nido

func _physics_process(delta):
	match estado_buitre:
		estados_buitre.muerto:
			pass
		estados_buitre.descansa:
			pass
		estados_buitre.vuela:
			if global_position.distance_to(destino) < 10 and objetivo != null:
				atacar()
			elif objetivo != null:
				volar( Vector2(objetivo.global_position.x +10 ,objetivo.global_position.y -60))
		estados_buitre.regresa:
			agente.target_position = nido
			destino = nido
			if global_position.distance_to(nido) > 3:
				var curLoc = global_transform.origin
				var nextLoc = agente.get_next_path_position()
				var newVel = (nextLoc - curLoc).normalized() * aceleracion
				velocity = newVel
			else:
				estado_buitre = estados_buitre.descansa
				descansar()
		estados_buitre.ataca:
			Eventos.emit_signal("mordiendo", danio)
			destino = objetivo.global_position
			if global_position.distance_to(destino) > 80:
				estado_buitre = estados_buitre.vuela
#			return
	
	# Add the gravity.
	if !is_on_floor() and (
		estado_buitre == estados_buitre.descansa or 
		estado_buitre == estados_buitre.muerto):
		velocity.y += gravity * (delta /2)
	elif is_on_floor() && not nido:
		nido = self.global_position
	
	if  velocity.x * 10 < -1 and estado_buitre != estados_buitre.ataca:
		$Animaciones.flip_h = false
	elif velocity.x * 10 > 1 and estado_buitre != estados_buitre.ataca:
		$Animaciones.flip_h = true
	move_and_slide()

func volar(pos: Vector2):
	if estado_buitre != estados_buitre.muerto:
		destino = pos
		estado_buitre = estados_buitre.vuela
		if str($Animaciones.animation) != "vuela":
			$Animaciones.play("vuela")
		velocity = global_position.direction_to(destino) * aceleracion

func _on_area_cuerpo_area_entered(area):
	if area.name == "bala":
		muere()

func muere():
		set_collision_mask_value(1, true)
		estado_buitre = estados_buitre.muerto
		velocity.x = 0
		$Animaciones.play("muerte")

func _on_radar_body_entered(body):
	if estado_buitre == estados_buitre.muerto:
		return
	objetivo = body
	$radar.scale =Vector2(1.5, 1.5)
	volar(Vector2(objetivo.global_position.x +1 ,objetivo.global_position.y -60))
	

func _on_radar_body_exited(body):
	if estado_buitre != estados_buitre.muerto:
		objetivo = null
		$radar.scale =Vector2(1.0, 1.0)
		estado_buitre = estados_buitre.regresa
	#	volar (nido)

func atacar():
	if estado_buitre != estados_buitre.muerto:
		velocity = Vector2(0,0)
		estado_buitre = estados_buitre.ataca
		$Animaciones.play("ataca")

func descansar():
	$Animaciones.play("idle")
	velocity = Vector2(0,0)

func _on_animaciones_animation_finished():
	if $Animaciones.animation == "muerte":
		var tween = create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
		tween.tween_property(self, "scale", Vector2(0,0),Tiempo.velocidad_reloj / 
			Tiempo.delta_tiempo * 2)
		Eventos.emit_signal("muere_perro", self.global_position +Vector2(0,30))
		tween.tween_callback(queue_free)

