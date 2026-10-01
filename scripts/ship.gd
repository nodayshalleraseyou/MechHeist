extends RigidBody2D
class_name Ship
@export var acceleration: float = 500.0
@export var max_speed: float = 250.0


@export var current_cargo : int
@export var max_cargo : int = 10


@export var team: String = ""

@export var equipped_item : Item

@export_category("Scenes")
@export var cargo_token : PackedScene

var ai: Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if SystemManager.instance:
		SystemManager.instance.register_ship(self)


func _exit_tree() -> void:
	if SystemManager.instance:
		SystemManager.instance.unregister_ship(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func move(direction: Vector2):
	apply_central_force(direction * acceleration)

func move_to(destination: Vector2) -> void:
	var to_destination: Vector2 = destination - global_position
	if to_destination.length() < 1.0:
		return
	move(to_destination.normalized())

# Like move_to, but eases off within slow_radius and brakes to a stop at the destination.
func arrive_at(destination: Vector2, slow_radius: float = 128.0) -> void:
	var to_destination: Vector2 = destination - global_position
	var desired_speed: float = max_speed * minf(to_destination.length() / slow_radius, 1.0)
	var desired_velocity: Vector2 = to_destination.normalized() * desired_speed
	var steering: Vector2 = (desired_velocity - linear_velocity) * mass * 10.0
	apply_central_force(steering.limit_length(acceleration))

func add_cargo(amount : int):
	current_cargo += amount 
	current_cargo = min(current_cargo,max_cargo)

func remove_cargo(amount : int) -> int:
	var removed: int = mini(amount, current_cargo)
	current_cargo -= removed
	return removed

func destory_cargo():
	current_cargo = 0

func is_cargo_full() -> bool:
	return current_cargo >= max_cargo

func is_cargo_empty() -> bool:
	return current_cargo <= 0

func aim_item(pos : Vector2):
	if equipped_item:
		equipped_item.aim(pos)

func use_item():
	if equipped_item:
		equipped_item.use(self)

func reload_item():
	if equipped_item:
		equipped_item.reload()

func deal_damage():
	explode()
	
func explode():
	scatter_cargo()
	queue_free()	
	
func scatter_cargo():
	print("scatter")
	for i in current_cargo:
		var token = cargo_token.instantiate() as CargoToken
		get_tree().current_scene.add_child(token)
		token.global_position = global_position
		token.scatter()
	current_cargo = 0
