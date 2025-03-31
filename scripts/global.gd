extends Node

var game_settings: GameSettings = preload("res://game_settings.tres")

var projectile_count: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func show_fps() -> bool:
	return game_settings.show_fps_counter

func show_projectile_count() -> bool:
	return game_settings.show_projectile_counter
