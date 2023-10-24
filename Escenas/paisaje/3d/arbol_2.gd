extends Node3D


func _ready():
	var escala_arbol: Vector3
	var escala = randf_range(0.5, 0.8)
	escala_arbol = Vector3(escala, escala * 1.1, escala)
	self.scale = escala_arbol
	self.rotation.y = randf_range(0,100)

func mover_arbol():
	var tween = create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
	var rotacion: Vector3
	
	rotacion = Vector3(randf_range(-0.05, 0.05),self.rotation.y,randf_range(-0.05, 0.05))
	tween.tween_property(self, "rotation",rotacion, 2)

func mover_origen():
	var tween = create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)

	tween.tween_property(self, "rotation",Vector3(0,self.rotation.y,0) , 2)
