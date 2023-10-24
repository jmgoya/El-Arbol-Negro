extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
## Variables o Atributos Export
var velocidad_mov_camara: Vector2 = Vector2(0.10, 0.10)
var rango_rotacion_camara_x:Vector2 = Vector2(-90.0, 30.0)
var rango_rotacion_camara_y:Vector2 = Vector2(0.0, 360.0)
var camara_x_invertida: bool = false
var camara_y_invertida: bool = false

var c := 0
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _unhandled_input(event: InputEvent) -> void:
	c += 1
	if event is InputEventMouseMotion:
		## Rotacion Eje X (Arriba - Abajo)
		rotation_degrees.x += event.relative.y * velocidad_mov_camara.y
		rotation_degrees.x = clamp(
			rotation_degrees.x,
			rango_rotacion_camara_x.x,
			rango_rotacion_camara_x.y
		)
		## Rotacion Eje Y (Derecha - Izquierda)
		rotation_degrees.y += event.relative.x * velocidad_mov_camara.x
		rotation_degrees.y = wrapf(
			rotation_degrees.y,
			rango_rotacion_camara_y.x,
			rango_rotacion_camara_y.y
		)
		
	#TODO: Solo para debug
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

func _physics_process(delta):
	# Add the gravity.
#	if not is_on_floor():
#		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
