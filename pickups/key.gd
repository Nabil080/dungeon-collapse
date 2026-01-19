class_name Key
extends Area2D


func _on_area_entered(area: Area2D) -> void:
	if not area.is_in_group("player"):
		pass
	GameManager.has_key = true
	queue_free()
