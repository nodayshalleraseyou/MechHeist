extends Control
class_name PercentageBar

@export var filling : ColorRect

func set_percentage(percentage : float):
	filling.scale.x = percentage
	pass
	
	
