extends Timer

@export var dia:int = 0
@export var hora:float = 1.0
@export var lapso:float = 8.0
var delta_tiempo:float = 0.2

func _ready():
	self.wait_time = lapso

func _on_timeout():
	print (hora)
	hora = hora + (lapso * delta_tiempo)
	if hora>= 24:
		hora = 0
	Eventos.emit_signal("tiempo_real",  dia, hora,0)
