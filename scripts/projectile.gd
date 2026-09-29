extends Area2D
class_name Projectile

var velocity: Vector2
var owner_ship: Ship
var _ignore_owner: bool = false

@export var lifetime: float = 10.0

func _ready() -> void:
	body_entered.connect(deal_damage)


func launch_projectile(new_velocity: Vector2, owner: Ship = null):
	velocity = new_velocity
	owner_ship = owner
	_ignore_owner = owner_ship != null
	global_rotation = velocity.angle()
	get_tree().create_timer(lifetime).timeout.connect(queue_free)


func _physics_process(delta: float) -> void:
	global_position += velocity * delta
	if _ignore_owner:
		if owner_ship == null or not is_instance_valid(owner_ship) or not overlaps_body(owner_ship):
			_ignore_owner = false


func deal_damage(node : Node2D):
	if node is Ship:
		if node == owner_ship and _ignore_owner:
			return
		node.deal_damage()
		queue_free()
	if node is Rock:
		queue_free()
	
