extends Node
class_name AIShip

var ship: Ship
var target: Ship
var state: int = -1



#methods for our unique AIs
func initial_state() -> int:
	return 0

func enter_state(new_state: int) -> void:
	pass


func exit_state(old_state: int) -> void:
	pass


func update_state(delta: float) -> void:
	pass



func _ready() -> void:
	var parent: Node = get_parent()
	if parent is Ship:
		ship = parent
		ship.ai = self
	change_state(initial_state())
	await get_tree().process_frame
	if ship != null and is_instance_valid(ship) and SystemManager.instance != null:
		SystemManager.instance.register_ship(ship)


func _physics_process(delta: float) -> void:
	if ship == null or not is_instance_valid(ship):
		return
	update_state(delta)

func change_state(new_state: int) -> void:
	if new_state == state:
		return
	exit_state(state)
	state = new_state
	enter_state(state)


func has_target() -> bool:
	return is_instance_valid(target)


func is_target_lost(lose_interest_range: float) -> bool:
	return not has_target() or ship.global_position.distance_to(target.global_position) > lose_interest_range


func acquire_target(detection_range: float) -> bool:
	target = find_nearest_enemy(detection_range)
	return has_target()


func distance_to_target() -> float:
	return ship.global_position.distance_to(target.global_position)


func find_nearest_enemy(max_range: float = INF) -> Ship:
	if SystemManager.instance == null:
		return null
	var nearest: Ship = null
	var nearest_dist: float = max_range
	for enemy in SystemManager.instance.get_enemies_of(ship.team):
		var dist: float = ship.global_position.distance_to(enemy.global_position)
		if dist <= nearest_dist:
			nearest_dist = dist
			nearest = enemy
	return nearest


func find_nearest_nebula() -> Nebula:
	if SystemManager.instance == null:
		return null
	return SystemManager.instance.find_nearest_nebula(ship.global_position)


func find_nearest_planet() -> Planet:
	if SystemManager.instance == null:
		return null
	return SystemManager.instance.find_nearest_planet(ship.global_position)


func reload_if_needed() -> void:
	var item: Item = ship.equipped_item
	if item == null or item.is_reloading or item.current_ammo > 0:
		return
	ship.reload_item()
