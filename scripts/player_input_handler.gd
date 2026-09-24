extends Node2D
class_name PlayerInputHandler
	
@export var player_ship : Ship



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !player_ship:
		get_tree().reload_current_scene()
		return
	
	player_ship.aim_item(get_global_mouse_position())
	if Input.is_action_pressed("use"):
		player_ship.use_item()
	if Input.is_action_just_pressed("reload"):
		player_ship.reload_item()
	if Input.is_action_just_pressed("hyperjump"):
		get_tree().reload_current_scene()

		

		
func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("left", "right", "up", "down")
	player_ship.move(direction)
	
