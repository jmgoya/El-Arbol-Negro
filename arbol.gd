extends Node2D

func _ready():
	Eventos.connect("tiempo", cambio_cielo)
	Eventos.connect("muere_perro", nace_hongo)
#	var lobo_scn = load ("res://Escenas/personajes/enemigos/lobo2.tscn")
#	var lobo_enemigo = lobo_scn.instance()
#	add_child(lobo_enemigo)
	

func cambio_cielo(dia, hora, cielo):
	var tween = create_tween()
	tween.tween_property($CanvasModulate, "color", cielo, 
		Tiempo.velocidad_reloj * Tiempo.delta_tiempo * 4)

func nace_hongo(posicion):
	print ("Nace un hongo en " + str(posicion))
	
