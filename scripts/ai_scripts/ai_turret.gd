extends AIShip
class_name AITurret

enum State{IDLE, ATTACK}

@export var detection_range : float = 500

# when enemy ship comes close, shoot and reload
# when it leaves, do nothing

#methods for our unique AIs
func initial_state() -> int:
	return State.IDLE

func enter_state(new_state: int) -> void:
	pass


func exit_state(old_state: int) -> void:
	pass


func update_state(delta: float) -> void:
	match state:
		State.IDLE:
			idle_state()
		State.ATTACK:
			attack_state()

func idle_state():
	#search for a target
	if acquire_target(detection_range):
		change_state(State.ATTACK)

func attack_state():
	if !target:
		change_state(State.IDLE)
		return
	if target.global_position.distance_to(ship.global_position) > detection_range:
		change_state(State.IDLE)
		return
	ship.aim_item(target.global_position)
	reload_if_needed()
	ship.use_item()
	
