extends Area2D

signal shoot(projectile: PackedScene, direction: float, location: Vector2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	var velocity = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	position += velocity * 400 * delta
