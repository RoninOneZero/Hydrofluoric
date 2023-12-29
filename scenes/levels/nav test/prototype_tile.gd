class_name GridBlock
extends Node3D

var is_active: bool = false

func show_marker() -> void:
    $NavMarker.show()
    is_active = true

func hide_marker() -> void:
    $NavMarker.hide()
    is_active = false