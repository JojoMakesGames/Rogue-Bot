extends Control


func _on_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Tests/Test_Factory.tscn")


func _on_return_to_title_pressed():
	get_tree().change_scene_to_file("res://Scenes/Levels/TitleScreen.tscn")
