extends Node2D

const BULLET_COUNT = 100
var x = 60

func _physics_process(_delta: float) -> void:
		#for i in range(BULLET_COUNT):
	#	$ProjectileController.spawn_projectile(Vector2.ZERO, Vector2(65, 0))
	#	await get_tree().create_timer(0.3).timeout
	pass
		
	
func _on_timer_timeout() -> void:
	for i in range(BULLET_COUNT):
		var angle = TAU / BULLET_COUNT * i
		var x := 300 * cos(angle)
		var y := 300 * sin(angle)
		$BulletManager.add_bullet(Vector2(x, y))
