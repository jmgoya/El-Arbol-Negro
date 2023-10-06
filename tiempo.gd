extends Timer

@export var hora: float = 8.0
@export var dia: int = 1
@export var velocidad_reloj: float = 4.0
@export var delta_tiempo: float = 0.2



func _on_timeout():
	hora = hora + (delta_tiempo * velocidad_reloj)
	if (hora >= 24):
		hora = 0
		dia += 1
	Eventos.emit_signal("tiempo", dia, hora, color_cielo(hora) )

func color_cielo(hora):
	var color: Color
	if hora >= 7:
		color = Color(1,0,1)
	if hora >= 10:
		color = Color(1,1,1)
	if hora >= 17:
		color = Color(1,0,0.4)
	if (hora >= 20 or hora <= 6):
		color = Color(0.01,0.01,0.2)
	return color
