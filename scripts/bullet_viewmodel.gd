class_name BulletViewModel
extends Node2D

signal bullet_created(total_count: int, location: Vector2)
signal bullets_updated(positions: PackedVector2Array)
signal bullet_destroyed

@export var model: BulletModel

func _ready() -> void:
	model.space = get_world_2d().get_space()


func _physics_process(delta: float) -> void:
	model.physics_update(delta)
	bullets_updated.emit(model.get_bullet_positions())


func _exit_tree() -> void:
	model.clear()


func spawn_bullet(velocity: Vector2) -> void:
	var bullet := model.spawn_bullet(global_position, velocity)
	bullet_created.emit(model.count(), Vector2(bullet.position))
