extends Node2D

@export var screen_fader : ScreenFader

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_button_pressed() -> void:
	screen_fader.fade_to_black("res://main_scene.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
