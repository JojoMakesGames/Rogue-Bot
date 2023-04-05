extends Control


func _on_button_pressed():
	print_debug("woo")
	get_tree().reload_current_scene()


func _on_return_to_title_pressed():
	get_tree().change_scene_to_file("res://Scenes/Levels/TitleScreen.tscn")
