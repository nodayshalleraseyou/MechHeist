extends Area2D
class_name CargoToken

@export var scatter_speed_min: float = 100.0
@export var scatter_speed_max: float = 300.0
@export var scatter_damp: float = 100.0

var velocity: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body):
	if body is Ship:
		body.add_cargo(1)
		queue_free()
		
		
func aim(pos : Vector2):
	look_at(pos)

func scatter():
	velocity = Vector2.RIGHT.rotated(randf() * TAU) * randf_range(scatter_speed_min, scatter_speed_max)


func _physics_process(delta: float) -> void:
	global_position += velocity * delta
	velocity = velocity.move_toward(Vector2.ZERO, scatter_damp * delta)
