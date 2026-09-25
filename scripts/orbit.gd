extends Node
class_name Orbit

@export var orbit_center : Node2D
@export var period_time : float 
@export var direction : int = 1
var radius : float = 0

var orbit_target : Node2D
var current_angle : float = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	orbit_target = get_parent()
	var offset_vector : Vector2 = orbit_target.global_position - orbit_center.global_position
	current_angle = offset_vector.angle()
	radius = orbit_target.global_position.distance_to(orbit_center.global_position)




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	simulate_orbit(delta)
	pass

func simulate_orbit(delta : float):
	current_angle += direction * 2.0 * PI / period_time * delta
	orbit_target.global_position = orbit_center.global_position + Vector2(cos(current_angle), sin(current_angle)) * radius

	
