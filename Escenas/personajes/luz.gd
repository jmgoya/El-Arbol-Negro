extends PointLight2D

@export var energia = 100
var poder_luz = Vector2(0.4,0.4)
var ultima_hora

func _ready():
	Eventos.tiempo.connect(desgaste)
	Eventos.luz.connect(click)
	$ProgressBar.max_value = energia
	$ProgressBar.value = energia
	ultima_hora= (Tiempo.dia * 24) + (Tiempo.hora)

func desgaste(dia, hora, cielo):
	if self.global_scale == poder_luz:
		energia = (energia - ( ((dia * 24) + hora)-ultima_hora))
		ultima_hora= (Tiempo.dia * 24) + (Tiempo.hora)
		$ProgressBar.value = energia
		if (energia <= 1) :
			click()
	

func click():
	
	if  self.global_scale == poder_luz  : 
		#esta encendida y hay que apagarla
		var tween_luz = create_tween()
		tween_luz.tween_property(self, "global_scale",Vector2(0,0), 1,)
	else:
		#esta apagada y hay que encenderla
		if energia > 0:
			ultima_hora = Tiempo.dia * 24 + Tiempo.hora
			var tween_luz = create_tween()
			tween_luz.tween_property(self, "global_scale",poder_luz, 1,)
	

func recargar():
	pass
