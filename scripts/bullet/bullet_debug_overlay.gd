class_name BulletDebugOverlay
extends CanvasItem

@export var width: float = 1.0
@export var antilizing: bool = false 

var bullet_manager: BulletManager

func _ready() -> void:
	bullet_manager = get_parent().get_node("BulletManager")

func _physics_process(_delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	if not bullet_manager:
		return

	if bullet_manager.bullets.is_empty():
		return

	var vectors = PackedVector2Array()
	var colors = PackedColorArray()

	for bullet in bullet_manager.bullets:
		bullet.debug(vectors, colors)

	draw_multiline_colors(vectors, colors, width, antilizing)	
