extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	Eventos.valores_player.connect(actualiza_valores)

func actualiza_valores(propiedad, valor):
	print ("Llegó la señal " + str(valor))
	match propiedad:
		"salud":
			$VBoxContainer/LabelSalud.set_text ("Salud " + str(round(valor)))
		"hora":
			$VBoxContainer2/LabelHora.set_text("Hora: " + valor)
		"dia":
			$VBoxContainer2/LabelDia.set_text("Día: " + str(valor))
