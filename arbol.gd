extends Node2D

@export var largo: int = 2
@export var cantidad_enemigos: int = 4

func _ready():
	Eventos.connect("tiempo", cambio_cielo)
	Eventos.connect("muere_perro", nace_hongo)
	cargar_suelo(largo)
	cargar_enemigos(cantidad_enemigos)

func cambio_cielo(dia, hora, cielo):
	var tween = create_tween()
	tween.tween_property($CanvasModulate, "color", cielo, 
		Tiempo.velocidad_reloj * Tiempo.delta_tiempo * 4)

func nace_hongo(posicion):
	print ("Nace un hongo en " + str(posicion))
	
func cargar_suelo(cantidad):
	#el suelo mide 16 x 158
	while cantidad > 0:
		var suelo_scn = load ("res://plataformas/suelo front.tscn")
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
		print (lobo_nuevo.global_position.x)
