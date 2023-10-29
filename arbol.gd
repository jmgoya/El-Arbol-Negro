extends Node2D

@export var largo: int = 4
@export var cantidad_enemigos: int = 15
@export var cantidad_plataformas: = 10

func _ready():
	Eventos.connect("tiempo", cambio_cielo)
	Eventos.connect("muere_perro", nace_hongo)
	cargar_suelo(largo)
	cargar_enemigos(cantidad_enemigos)
	cargar_plataformas(cantidad_plataformas)

func cambio_cielo(dia, hora, cielo):
	var tween = create_tween()
	tween.tween_property($CanvasModulate, "color", cielo, 
		Tiempo.velocidad_reloj / Tiempo.delta_tiempo * 2)

func nace_hongo(posicion):
	var hongo_scn = load("res://Escenas/paisaje/hongos/hongo2.tscn")
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
		#((largo * 2200 ) / cantidad_enemigos) * (
		#		randi_range (0, int ($Enemigos.get_child_count() ))) 

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
		print ("Plataforma posicion Y " + str(plataforma_nueva.global_position.y))
		print ("Plataforma posicion X " + str(plataforma_nueva.global_position.x))
		plataforma_nueva.global_position.y = -45
		
		if (randi() % 3) == 1:
			print ("duplicada")
			var pos_temp = posicion
			orden = 1
			while ((orden%2) > 0 ) or orden == 4: #que no sea la plataforma pozo
				orden = randi()% 6 + 2
			plataforma_nueva_scn = load (Globales.plataformas_tscn[orden - 2])
			plataforma_nueva = plataforma_nueva_scn.instantiate()
			$Estructuras.add_child(plataforma_nueva)
			plataforma_nueva.global_position = Vector2(posicion, -200)
			
		posicion = posicion + Globales.plataformas_tscn[orden - 1]
		print ("Plataforma: " + str (orden - 2) + " Posición relativa: 
			" + str(Globales.plataformas_tscn[orden - 1]) + "Pos. Global: " + str (posicion))
		orden = 1
