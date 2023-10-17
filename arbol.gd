extends Node2D

@export var largo: int = 2
@export var cantidad_enemigos: int = 6
@export var cantidad_plataformas: Vector2 = Vector2(6 , true)

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
	print ("Nace un hongo en " + str(posicion))
	
func cargar_suelo(cantidad):
	#el suelo mide 16 x 158
	while cantidad > 0:
		var suelo_scn = load ("res://estructuras/suelo front.tscn")
		var suelo = suelo_scn.instantiate()
		$Estructuras.add_child (suelo, true)
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
		var maximo = (2200 * largo)
		lobo_nuevo.global_position.x =  randi_range(1000, maximo)
		#((largo * 2200 ) / cantidad_enemigos) * (
		#		randi_range (0, int ($Enemigos.get_child_count() ))) 

func cargar_plataformas(cantidad):
	var posicion: int = 500
	var orden:int = 1
	print (cantidad[0], " ", cantidad[1])
	for numero in cantidad[0]:
		while (orden%2) > 0 :
			orden = randi()% 6 + 2
		var plataforma_nueva_scn = load (Globales.plataformas_tscn[orden - 2])
		var plataforma_nueva = plataforma_nueva_scn.instantiate()
		plataforma_nueva.global_position.x = posicion
		$Estructuras.add_child(plataforma_nueva)
		if (randi() % 2) == 0:
			var pos_temp = posicion
			print ("Duplicado")
			orden = 1
			while ((orden%2) > 0 ) or orden == 1: #que no sea la plataforma pozo
				orden = randi()% 6 + 2
			plataforma_nueva_scn = load (Globales.plataformas_tscn[orden - 2])
			plataforma_nueva = plataforma_nueva_scn.instantiate()
			plataforma_nueva.global_position = Vector2(posicion, -200)
			$Estructuras.add_child(plataforma_nueva)
#			if posicion > 

		posicion = posicion + Globales.plataformas_tscn[orden - 1]
		print ("Plataforma: " + str (orden - 2) + " Posición relativa: 
			" + str(Globales.plataformas_tscn[orden - 1]) + "Pos. Global: " + str (posicion))
		orden = 1
