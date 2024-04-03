extends Control

@onready var Selector = $Selector
@onready var ResumeButtom = $Background/HBoxContainer/VBoxContainer/ResumeButton
@onready var SettingsButtom = $Background/HBoxContainer/VBoxContainer/SettingsButton
@onready var MainMenuButtom = $Background/HBoxContainer/VBoxContainer/MainMenuButton

func _ready():
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED

func _input(event):
	if event.is_action_pressed("ui_cancel") and not $"..".Inventory.visible:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		hide()
		$"..".stopTransition = true
		get_tree().paused = false
		pass


func setSelectorPosition(node: Label):
	Selector.visible = true
	Selector.position.y = node.position.y + $Background.position.y
	
func unsetSelectorPosition():
	Selector.visible = false


func _on_background_gui_input(_event):
	unsetSelectorPosition()

func _on_resume_button_gui_input(_event):
	setSelectorPosition(ResumeButtom)
	if Input.is_action_just_pressed("Click"):
		get_tree().paused = false
		visible = false
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _on_settings_button_gui_input(_event):
	setSelectorPosition(SettingsButtom)


func _on_main_menu_button_gui_input(_event):
	setSelectorPosition(MainMenuButtom)
	if Input.is_action_just_pressed("Click"):
		get_tree().paused = false
		get_tree().change_scene_to_file.call_deferred("res://src/menu/scene.tscn")
