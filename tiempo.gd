extends Timer

@export var hora: float = 19.0
@export var dia: int = 1
@export var velocidad_reloj: float = 2
@export var delta_tiempo: float = 0.5

func _ready():
	self.wait_time = velocidad_reloj

func _on_timeout():
	hora = hora + (delta_tiempo * velocidad_reloj)
	if (hora >= 24):
		hora = 0
		dia += 1
		Eventos.emit_signal("valores_player", "dia", dia)
#	var hora_str = str(round(hora)) + "hs " + str((hora - round(hora))* 60) + "min"
	Eventos.emit_signal("tiempo", dia, hora, color_cielo(hora) )
	Eventos.emit_signal("valores_player", "hora",  str(round(hora)) + 
		":" + str(abs(hora - round(hora))* 60) + " hs")

func color_cielo(hora):
	var color: Color
	if hora >= 6:
		color = Color(1,0,1)
	if hora >= 9:
		color = Color(1,1,1)
	if hora >= 17:
		color = Color(1,0,0.4)
	if (hora >= 20 or hora <= 6):
		color = Color(0.03,0.03,0.03)
	return color
