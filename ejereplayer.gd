extends CharacterBody2D

const speed = 30

@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D

func _ready():
	get_parent().connect("click", hacer_camino)

func _physics_process(_delta: float) -> void:
	var dir = to_local(nav_agent.get_next_path_position()).normalized()
	velocity = dir * speed
	move_and_slide()
	
func hacer_camino(objetivo :Vector2) -> void:
	nav_agent.target_position = objetivo - self.global_position
