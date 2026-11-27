class_name ExitLadder
extends Area2D


func _on_area_entered(area: Area2D) -> void:
	if not area.is_in_group("player") or not GameManager.can_open_door:
		return
	GameManager.next_level.call_deferred()
