class_name GameSettings
extends Resource

@export_range(0.1, 1, 0.01) var sensitivity := 1.0;

@export_subgroup("Debug")
@export var show_fps_counter: bool = false
@export var show_projectile_counter: bool = false
