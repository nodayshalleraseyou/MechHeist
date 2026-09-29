extends Node
class_name SystemManager

static var instance: SystemManager

var ships: Array[Ship] = []
var nebulae: Array[Nebula] = []
var planets: Array[Planet] = []


# Set in _enter_tree so the instance exists before any sibling's _ready runs.
func _enter_tree() -> void:
	instance = self


func _exit_tree() -> void:
	if instance == self:
		instance = null


func register_ship(ship: Ship) -> void:
	if not ships.has(ship):
		ships.append(ship)


func unregister_ship(ship: Ship) -> void:
	ships.erase(ship)


func register_nebula(nebula: Nebula) -> void:
	if not nebulae.has(nebula):
		nebulae.append(nebula)


func unregister_nebula(nebula: Nebula) -> void:
	nebulae.erase(nebula)


func register_planet(planet: Planet) -> void:
	if not planets.has(planet):
		planets.append(planet)


func unregister_planet(planet: Planet) -> void:
	planets.erase(planet)


func get_ships() -> Array[Ship]:
	prune_invalid(ships)
	return ships


func get_nebulae() -> Array[Nebula]:
	prune_invalid(nebulae)
	return nebulae


func get_planets() -> Array[Planet]:
	prune_invalid(planets)
	return planets


func get_enemies_of(team: String) -> Array[Ship]:
	var enemies: Array[Ship] = []
	for ship in get_ships():
		if ship.team != team:
			enemies.append(ship)
	return enemies


func find_nearest_nebula(position: Vector2) -> Nebula:
	return find_nearest(get_nebulae(), position)


func find_nearest_planet(position: Vector2) -> Planet:
	return find_nearest(get_planets(), position)


func find_nearest(nodes: Array, position: Vector2) -> Node2D:
	var nearest: Node2D = null
	var nearest_dist: float = INF
	for node in nodes:
		var dist: float = position.distance_to(node.global_position)
		if dist < nearest_dist:
			nearest_dist = dist
			nearest = node
	return nearest


func prune_invalid(nodes: Array) -> void:
	for i in range(nodes.size() - 1, -1, -1):
		if not is_instance_valid(nodes[i]):
			nodes.remove_at(i)
