extends Area2D
class_name Nebula

@export var seconds_per_cargo: float = 1.0
@export var cargo_per_tick: int = 1

var ships_inside: Dictionary = {}


func _ready() -> void:
	if SystemManager.instance:
		SystemManager.instance.register_nebula(self)
	body_entered.connect(on_body_entered)
	body_exited.connect(on_body_exited)


func _exit_tree() -> void:
	if SystemManager.instance:
		SystemManager.instance.unregister_nebula(self)


# Random point inside the nebula's collision shape, pulled in by margin so ships sit fully inside.
func random_point(margin: float = 0.8) -> Vector2:
	for child in get_children():
		if child is CollisionShape2D and child.shape is CircleShape2D:
			var radius: float = child.shape.radius * margin
			var local: Vector2 = Vector2.from_angle(randf() * TAU) * radius * sqrt(randf())
			return child.global_transform * local
		if child is CollisionShape2D and child.shape is RectangleShape2D:
			var half: Vector2 = child.shape.size * 0.5 * margin
			var local: Vector2 = Vector2(randf_range(-half.x, half.x), randf_range(-half.y, half.y))
			return child.global_transform * local
	return global_position


func _physics_process(delta: float) -> void:
	for ship in ships_inside.keys():
		if not is_instance_valid(ship):
			ships_inside.erase(ship)
	if seconds_per_cargo <= 0.0 or cargo_per_tick <= 0:
		return
	for ship in ships_inside.keys():
		ships_inside[ship] += delta
		#if ships_inside[ship] >= seconds_per_cargo:
			#ships_inside[ship] = 0.0
			#ship.add_cargo(cargo_per_tick)
		while ships_inside[ship] >= seconds_per_cargo:
			ships_inside[ship] -= seconds_per_cargo
			ship.add_cargo(cargo_per_tick)


func on_body_entered(body: Node2D) -> void:
	if body is Ship and not ships_inside.has(body):
		ships_inside[body] = 0.0


func on_body_exited(body: Node2D) -> void:
	if body is Ship:
		ships_inside.erase(body)
