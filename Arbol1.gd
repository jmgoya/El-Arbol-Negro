extends Node3D

func _ready():
	var scala_arbol: Vector3
	scala_arbol = Vector3(randf_range(1.1, 1.0),
		randf_range(2, 1.0),
		randf_range(1.1, 1.0))
	self.scale = scala_arbol
	self.rotation.y = randf_range(0,10)

func mover_arbol():
	var tween = create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
	var movimiento: Vector3
	var dimencion: Vector3
	var rotacion: Vector3
	var arbol_tree = $copas_grandes
	var arbol
	
	
	rotacion = Vector3(randf_range(-0.05, 0.05),0,0)
	tween.tween_property(self, "rotation",rotacion, 2)
	
	for i in arbol_tree.get_child_count():
		arbol = arbol_tree.get_child(i)
		movimiento = Vector3(arbol.position.x + randf_range(-0.02, 0.02),
			arbol.position.y,
			arbol.position.z + randf_range(-0.01, 0.01))
		dimencion = Vector3(randf_range(1, 1.1),
			arbol.scale.y,
			randf_range(1, 1.1))
		tween.tween_property(arbol, "position", movimiento, 2)
		tween.tween_property(arbol, "scale", dimencion, 2)

func mover_origen():
	var tween = create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
	var arbol_tree = $copas_grandes
	var movimiento: Vector3
	var arbol

	tween.tween_property(self, "rotation",Vector3(0,0,0) , 2)

	for indice in arbol_tree.get_child_count():
		arbol = arbol_tree.get_child(indice)
		if indice == 0:
			movimiento = Vector3(-0.3,1.38,-0.56)
		elif indice == 1:
			movimiento = Vector3(-0.25,1.38,-0.74)
		else:
			movimiento = Vector3(-0.52,1.38,-0.74)
		tween.tween_property(arbol, "rotation.x", 0.0, 2)
		tween.tween_property(arbol, "position", movimiento, 2)
		tween.tween_property(arbol, "scale", Vector3(1,0.5,1), 2 )
