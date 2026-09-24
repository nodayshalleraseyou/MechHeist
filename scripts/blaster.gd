extends Item
class_name Blaster

@export var projectile_ps : PackedScene

@export var spawn_point : Node2D
@export var muzzle_flash : AnimatedSprite2D
@export var body_sprite : Sprite2D

@export_category("Stats")
@export var projectile_speed : float = 100
@export var fire_rate : float = 5.0
@export var kickback_distance : float = 6.0
@export var kickback_duration : float = 0.15

var cooldown : float = 0.0
var tween : Tween
var base_position : Vector2



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	base_position = body_sprite.position
	muzzle_flash.visible = false
	pass # Replace with function body.	muzzle_flash.visible = true

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super._process(delta)
	cooldown = maxf(0.0, cooldown - delta)

func use(ship : Ship):

	if cooldown > 0.0:
		return

	if is_reloading:
		return
		
	if current_ammo < 1:
		return
	current_ammo -= 1
	cooldown = 1.0 / fire_rate
	muzzle_flash.visible = true
	muzzle_flash.stop()
	muzzle_flash.play("default")
	if tween:
		tween.kill()
	body_sprite.position = base_position + Vector2(-kickback_distance, 0)
	tween = create_tween()
	tween.tween_property(body_sprite, "position", base_position, kickback_duration).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	var projectile = projectile_ps.instantiate() as Projectile
	get_tree().current_scene.add_child(projectile)
	projectile.global_position = spawn_point.global_position
	projectile.global_rotation = global_rotation
	var launch_velocity = global_transform.x * projectile_speed + ship.linear_velocity
	projectile.launch_projectile(launch_velocity)


func _on_muzzle_flash_animation_finished() -> void:
	muzzle_flash.visible = false
