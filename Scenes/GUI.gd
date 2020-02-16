extends CanvasLayer

func update_score(player1_score: int, player2_score: int):
	get_node("GUI/NinePatchRect/HBoxContainer/Playe1Score/Label").text = str(player1_score)
	get_node("GUI/NinePatchRect/HBoxContainer/Playe2Score/Label").text = str(player2_score)

func game_over():
	$GUI/Popup.show()


func _on_Button_pressed():
	update_score(0, 0)
	$GUI/Popup.hide()
	get_tree().call_group("Game", "retry")
