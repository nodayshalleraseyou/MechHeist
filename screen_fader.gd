extends CanvasLayer
class_name ScreenFader

@export var fade_color: Color = Color.BLACK
@export var fade_duration: float = 1.0
@export var color_rect : ColorRect

var tween: Tween


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	fade_from_black()


func fade_from_black():
	if tween:
		tween.kill()
	color_rect.color = Color(fade_color.r, fade_color.g, fade_color.b, 1.0)
	tween = create_tween()
	tween.tween_property(color_rect, "color:a", 0.0, fade_duration)


func fade_to_black(scene_name: String):
	if tween:
		tween.kill()
	color_rect.color = Color(fade_color.r, fade_color.g, fade_color.b, 0.0)
	tween = create_tween()
	tween.tween_property(color_rect, "color:a", 1.0, fade_duration)
	tween.tween_callback(get_tree().change_scene_to_file.bind(scene_name))
