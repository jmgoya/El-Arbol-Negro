extends Node

var guardado_archivo = "user://salvar_juego.save"

# Called when the node enters the scene tree for the first time.
func _ready():
	leer_juego()

func _salvar_juego():
	pass

func leer_juego():
	pass

func _notification(what):
	print (what)
	
