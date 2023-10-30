extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	Eventos.valores_player.connect(actualiza_valores)
	ajustar_ui()

func ajustar_ui():
#	$HBoxContainer.
	pass

func actualiza_valores(propiedad, valor):
	match propiedad:
		"salud":
#			$VBoxContainer3/VBoxContainer/LabelSalud.set_text ("Salud " + str(round(valor)))
			$VBoxContainer3/VBoxContainer/ProgressBarSalud.value = valor
		"hora":
			$VBoxContainer2/LabelHora.set_text("Hora: " + valor)
		"dia":
			$VBoxContainer2/LabelDia.set_text("Día: " + str(valor))
		"mochila":
			$VBoxContainer3/VBoxContainer2/HBoxContainer/LabelHongosComida.text = str(valor[0])
			$VBoxContainer3/VBoxContainer2/HBoxContainer2/LabelHongosSalud.text = str(valor[1])
			$VBoxContainer3/VBoxContainer2/HBoxContainer3/LabelHongosPsicodelico.text = str(valor[2])
			$VBoxContainer3/VBoxContainer2/HBoxContainer4/LabelHongosVeneno.text = str(valor[3])
