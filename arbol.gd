extends Node2D

func _ready():
	Eventos.connect("tiempo", cambio_cielo)

func cambio_cielo(dia, hora, cielo):
	var tween = create_tween()
	tween.tween_property($CanvasModulate, "color", cielo, 
		Tiempo.velocidad_reloj * Tiempo.delta_tiempo * 4)
