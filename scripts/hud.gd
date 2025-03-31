class_name HUD
extends CanvasLayer

var debug_panel: Label

func _ready() -> void:
	debug_panel = $"Debug Label"

func _process(_delta: float) -> void:
	var debug_info: String = ""
	
	if Global.show_fps():
		debug_info += "FPS %d\n" % Engine.get_frames_per_second()
		
	if Global.show_projectile_count():
		debug_info += "Projectiles: %d\n" % Global.projectile_count
	
	debug_panel.text = debug_info
