extends Node2D

var tipos_de_hongo = ["comida", "sanacion", "alucinogeno", "veneno"]
var tipo
var hongo_intensidad
var intensidad = 0
var experiencia_player

# Called when the node enters the scene tree for the first time.
func _ready():
	Eventos.comer_recoger.connect(recogido)
	#elige el hongo
	hongo_intensidad = randi() % 49 + 1
	var imagen = $imagenes.get_child(hongo_intensidad)
	imagen.visible = true
	tipo = int (hongo_intensidad / 10) - 1
	match tipo:
		0:
			$info/AnimationPlayer.play("blanco")
		1:
			$info/AnimationPlayer.play("cyan")
		2:
			$info/AnimationPlayer.play("purpura")
		3:
			$info/AnimationPlayer.play("rojo")
	intensidad = (int(hongo_intensidad -( (tipo + 1) * 10))+1)
	$info/Label.text = str(intensidad)
	if (experiencia_player >= intensidad):
		$info/Label.visible = true
	
	
	var tween = create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
	self.scale = Vector2 (0,0)
	tween.tween_property(self, "scale", Vector2(0.3,0.3), 
		Tiempo.velocidad_reloj / Tiempo.delta_tiempo )

func recogido(area):
	if area.name == self.name:
		#aca se come al hongo asi que debe enviar su info y desaparecer
		self.queue_free()
