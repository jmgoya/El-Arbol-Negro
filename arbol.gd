extends Node2D

@export var largo: int = 4
@export var cantidad_enemigos: int = 35
@export var cantidad_plataformas: = 10
@export var buitres: int = 4

var hongo_scn = load("res://Escenas/paisaje/hongos/hongo.tscn")

func _ready():
	Eventos.connect("tiempo", cambio_cielo)
	Eventos.connect("muere_perro", nace_hongo)
	cargar_suelo(largo)
	cargar_enemigos(cantidad_enemigos)
	cargar_plataformas(cantidad_plataformas)
	cargar_buitres (buitres)

func cambio_cielo(dia, hora, cielo):
	var tween = create_tween()
	tween.tween_property($CanvasModulate, "color", cielo, 
		Tiempo.velocidad_reloj / Tiempo.delta_tiempo )

func nace_hongo(posicion):
	var hongo = hongo_scn.instantiate()
	hongo.global_position = Vector2(posicion)
	hongo.experiencia_player = $Heroe.experiencia
	$recursos.add_child(hongo, true)
	
	
func cargar_suelo(cantidad):
	#el suelo mide 16 x 158
	while cantidad > 0:
		var suelo_scn = load ("res://estructuras/suelo front.tscn")
		var suelo = suelo_scn.instantiate()
		$Estructuras.add_child (suelo, false)
		cantidad -= 1
	for suelo_nuevo in $Estructuras.get_children():
		suelo_nuevo.global_position.x = (2448 * (cantidad)) - 300
		cantidad += 1

func cargar_enemigos(cantidad):
	while cantidad > 0:
		var lobo_scn = load ("res://Escenas/personajes/enemigos/lobo2.tscn")
		var lobo_enemigo = lobo_scn.instantiate()
		$Enemigos.add_child (lobo_enemigo)
		cantidad -= 1
	for lobo_nuevo in $Enemigos.get_children():
		var maximo = (2300 * largo)
		lobo_nuevo.global_position.x =  randi_range(500, maximo)

func cargar_plataformas(cantidad):
	var posicion: int = 500
	var orden:int = 1
	for numero in cantidad:
		while (orden%2) > 0 :
			orden = randi()% 6 + 2
		var plataforma_nueva_scn = load (Globales.plataformas_tscn[orden - 2])
		var plataforma_nueva = plataforma_nueva_scn.instantiate()
		$Estructuras.add_child(plataforma_nueva)
		plataforma_nueva.global_position.x = posicion
		plataforma_nueva.global_position.y = -45
		
		if (randi() % 3) == 1:
			var pos_temp = posicion
			orden = 1
			while ((orden%2) > 0 ) or orden == 4: #que no sea la plataforma pozo
				orden = randi()% 6 + 2
			plataforma_nueva_scn = load (Globales.plataformas_tscn[orden - 2])
			plataforma_nueva = plataforma_nueva_scn.instantiate()
			$Estructuras.add_child(plataforma_nueva)
			plataforma_nueva.global_position = Vector2(posicion, -300)
			
		posicion = posicion + Globales.plataformas_tscn[orden - 1]

func cargar_buitres (buitres):
#	print (buitres)
	var pos_nido = 800
	var nido_nuevo_scn = load ("res://Escenas/paisaje/nido.tscn")
	var buitre_scn = load("res://Escenas/personajes/enemigos/buitre.tscn")
	var nido_nuevo
	var buitre_nuevo
	for i in buitres:
		nido_nuevo = nido_nuevo_scn.instantiate()
		buitre_nuevo = buitre_scn.instantiate()
		$Enemigos/Nidos.add_child(buitre_nuevo)
		$Enemigos/Nidos.add_child(nido_nuevo)
		pos_nido = randi() %1000 + pos_nido +800
		nido_nuevo.global_position = Vector2(pos_nido, 185)
		buitre_nuevo.global_position = Vector2(pos_nido, 185 - 10)

	
