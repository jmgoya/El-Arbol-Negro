extends ParallaxBackground


# Called when the node enters the scene tree for the first time.
func _ready():
	Eventos.connect("tiempo", cambio_cielo)


func cambio_cielo(dia, hora, cielo):
	var tween = create_tween()
	tween.tween_property($CanvasModulate, "color", cielo, 
		Tiempo.velocidad_reloj * Tiempo.delta_tiempo * 4)
	print ("cambio el cielo")
	print (hora)
