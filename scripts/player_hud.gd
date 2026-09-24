extends CanvasLayer
class_name PlayerHUD

@export var player_ship : Ship
@export var item_out_of_label : OutOfLabel
@export var item_percentage_bar : PercentageBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player_ship.equipped_item:
		var item = player_ship.equipped_item
		if item.is_reloading:
			item_percentage_bar.set_percentage(1.0 - (item.reload_time_left / item.reload_time))
		else:
			item_percentage_bar.set_percentage(item.get_fill_percentage())
		item_out_of_label.fill_out_of_label(item.current_ammo, item.max_ammo)
