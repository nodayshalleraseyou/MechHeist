extends Sprite2D
class_name Planet

var stored_cargo: int = 0


func _ready() -> void:
	if SystemManager.instance:
		SystemManager.instance.register_planet(self)


func _exit_tree() -> void:
	if SystemManager.instance:
		SystemManager.instance.unregister_planet(self)


func take_cargo(ship : Ship):
	stored_cargo += ship.current_cargo
	ship.destory_cargo()
