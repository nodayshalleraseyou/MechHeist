extends RigidBody2D
class_name Ship
@export var acceleration: float = 500.0


@export var current_cargo : int
@export var max_cargo : int = 10


@export var equipped_item : Item

@export_category("Scenes")
@export var cargo_token : PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func move(direction: Vector2):
	apply_central_force(direction * acceleration)

func add_cargo(amount : int):
	current_cargo += amount 
	current_cargo = min(current_cargo,max_cargo)

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
