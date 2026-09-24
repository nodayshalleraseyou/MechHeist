extends Area2D
class_name Projectile

var velocity: Vector2

@export var lifetime: float = 10.0

func _ready() -> void:
	body_entered.connect(deal_damage)


func launch_projectile(new_velocity: Vector2):
	velocity = new_velocity
	global_rotation = velocity.angle()
	get_tree().create_timer(lifetime).timeout.connect(queue_free)


func _physics_process(delta: float) -> void:
	global_position += velocity * delta


func deal_damage(node : Node2D):
	if node is Ship:
		node.deal_damage()
	
