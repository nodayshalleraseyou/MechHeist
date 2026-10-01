extends AIShip
class_name AIHarvester

enum State{HARVEST, DELIVERY, COLLECT}

var current_nebula : Nebula
var current_planet : Planet
var dropoff_point : Vector2
const NEBULA_DIST : float = 100
const DELIVERY_DIST : float = 100



#methods for our unique AIs
func initial_state() -> int:
	return State.HARVEST

func enter_state(new_state: int) -> void:
	pass


func exit_state(old_state: int) -> void:
	pass


func update_state(delta: float) -> void:
	match state:
		State.HARVEST:
			harvest_state()
		State.DELIVERY:
			delivery_state()
		State.COLLECT:
			collect_state()
				

func harvest_state():
	if ship.is_cargo_full():
		change_state(State.DELIVERY)
		return
	if !is_instance_valid(current_nebula):
		current_nebula = SystemManager.instance.find_nearest_nebula(ship.global_position)
	if !is_instance_valid(current_nebula):
		#probably shouldn't ever happen
		return
	ship.move_to(current_nebula.global_position)
	if ship.global_position.distance_to(current_nebula.global_position) < NEBULA_DIST:
		change_state(State.COLLECT)
		return
	

func collect_state():
	if ship.is_cargo_full():
		change_state(State.DELIVERY)
		return

func delivery_state():
	if !is_instance_valid(current_planet):
		current_planet = SystemManager.instance.find_nearest_planet(ship.global_position)
		dropoff_point = current_planet.global_position
	if !is_instance_valid(current_planet):
		#oh no!
		return
	if ship.global_position.distance_to(dropoff_point) > 10:
		ship.move_to(dropoff_point)
	if ship.global_position.distance_to(current_planet.global_position) < DELIVERY_DIST:
		current_planet.take_cargo(ship)
		
		change_state(State.HARVEST)
		return


#ship should go to nebula to gather cargo
# when full, go to a dropoff planet
