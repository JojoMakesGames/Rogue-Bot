extends Control


func _on_button_pressed():
	print_debug("woo")
	get_tree().change_scene_to_file("res://Scenes/Levels/TitleScreen.tscn")
