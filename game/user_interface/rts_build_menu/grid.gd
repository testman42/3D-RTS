extends Node

func change_button_visibility(button_list):
	for button in get_children():
		button.hide()
		for button_name in button_list:
			if button.name == button_name:
				button.show()
