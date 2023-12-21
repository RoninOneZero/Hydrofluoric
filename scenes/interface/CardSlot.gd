extends TextureButton

var y_offset: int = -50

func raise_position() -> void:
	position.y += y_offset

func lower_position() ->void:
	position.y -= y_offset



func _on_focus_entered() -> void:
	raise_position()

func _on_focus_exited() -> void:
	lower_position()
