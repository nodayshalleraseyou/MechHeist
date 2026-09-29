extends Area2D
class_name GravityWell

@export var pull_acceleration: float = 800.0

var captured_projectiles: Array[Projectile] = []


func _ready() -> void:
	area_entered.connect(on_area_entered)
	area_exited.connect(on_area_exited)


func _physics_process(delta: float) -> void:
	for i in range(captured_projectiles.size() - 1, -1, -1):
		var projectile := captured_projectiles[i]
		if not is_instance_valid(projectile):
			captured_projectiles.remove_at(i)
			continue
		apply_gravity(projectile, delta)


func apply_gravity(projectile: Projectile, delta: float) -> void:
	var offset: Vector2 = global_position - projectile.global_position
	if offset.length() < 0.01:
		return
	var toward_center: Vector2 = offset.normalized()
	projectile.velocity += toward_center * pull_acceleration * delta
	if projectile.velocity.length() > 0.01:
		projectile.global_rotation = projectile.velocity.angle()


func on_area_entered(area: Area2D) -> void:
	if area is Projectile and not captured_projectiles.has(area):
		captured_projectiles.append(area)


func on_area_exited(area: Area2D) -> void:
	if area is Projectile:
		captured_projectiles.erase(area)
