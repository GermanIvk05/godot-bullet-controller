extends Node2D

@export var shape: Shape2D

@export var bullet_count: int = 12
@export var radius: float = 1.0
@export var bullet_speed: float = 450.0

var screen_center: Vector2

func _ready() -> void:
	screen_center = get_viewport_rect().get_center()


func _on_spawn_circle_button_pressed() -> void:
	for i in bullet_count:
		var angle := TAU * float(i) / float(bullet_count)
		var dir := Vector2.RIGHT.rotated(angle)
		var bullet := RegularBullet.new(screen_center, shape, get_world_2d().get_space())
		
		bullet.set_velocity(dir * bullet_speed)
		$BulletController.add_bullet(bullet)
