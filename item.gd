extends Node2D
class_name Item

var current_ammo : int = 10
var max_ammo : int = 10

@export var reload_time : float = 2.0
var reload_time_left : float = 0.0
var is_reloading : bool = false

func _ready() -> void:
	current_ammo = max_ammo

func _process(delta: float) -> void:
	if is_reloading:
		reload_time_left = maxf(0.0, reload_time_left - delta)
		if reload_time_left <= 0.0:
			is_reloading = false
			current_ammo = max_ammo

func aim(pos : Vector2):
	look_at(pos)
	
func use(ship : Ship):
	pass
	
func reload():
	if is_reloading:
		return
	if current_ammo == max_ammo:
		return
	is_reloading = true
	reload_time_left = reload_time

func get_fill_percentage() -> float:
	if is_reloading:
		return 1.0 - (reload_time_left / reload_time)
	return float(current_ammo) / float(max_ammo)
