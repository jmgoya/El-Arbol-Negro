extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var tween = create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
	self.scale = Vector2 (0,0)
	tween.tween_property(self, "scale", Vector2(1,1), 
		Tiempo.velocidad_reloj / Tiempo.delta_tiempo )


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
