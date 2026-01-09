class_name Root
extends Node2D

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"): get_tree().quit() 
	if event.is_action_pressed("restart_level"): get_tree().reload_current_scene()
