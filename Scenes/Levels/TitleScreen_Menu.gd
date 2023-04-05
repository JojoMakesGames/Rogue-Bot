extends Node2D

@onready var control_menu: Panel = $CanvasLayer/Panel

func _on_button_play_pressed():
	get_tree().change_scene_to_file("res://Scenes/Tests/Test_Factory.tscn")


func _on_button_cont_pressed():
	control_menu.visible = !control_menu.visible


func _on_button_return_pressed():
	control_menu.visible = !control_menu.visible


func _on_button_quit_pressed():
	get_tree().quit()
