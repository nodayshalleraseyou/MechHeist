extends ShipAI
class_name GuardAI

@export var waypoints: Array[Vector2] = []
@export var waypoint_tolerance: float = 32.0
@export var detection_range: float = 600.0
@export var attack_range: float = 400.0
@export var lose_interest_range: float = 900.0

var waypoint_index: int = 0
var target: Ship


func _physics_process(delta: float) -> void:
	if ship == null or not is_instance_valid(ship):
		return
	update_target()
	drive(delta)


func drive(delta: float) -> void:
	if target != null and is_instance_valid(target):
		var dist: float = ship.global_position.distance_to(target.global_position)
		if dist > attack_range:
			ship.move_to(target.global_position)
		ship.aim_item(target.global_position)
		if dist <= attack_range:
			reloadIfNeeded()
			ship.use_item()
	elif not waypoints.is_empty():
		var waypoint: Vector2 = waypoints[waypoint_index]
		if ship.global_position.distance_to(waypoint) <= waypoint_tolerance:
			waypoint_index = (waypoint_index + 1) % waypoints.size()
		else:
			ship.move_to(waypoint)


func update_target() -> void:
	if target != null and is_instance_valid(target):
		if ship.global_position.distance_to(target.global_position) > lose_interest_range:
			target = null
		else:
			return
	var nearest: Ship = find_nearest_enemy()
	if nearest != null and ship.global_position.distance_to(nearest.global_position) <= detection_range:
		target = nearest
	else:
		target = null
