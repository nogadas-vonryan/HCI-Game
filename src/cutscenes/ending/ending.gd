extends Node2D

@onready var grid = $Control/GridContainer
@onready var timer = $Timer
@onready var control = $Control
@onready var fade = $AnimationPlayer

const members = {
	"Von Ryan Nogadas": "Programmer",
	"Mark Louie Cahigan": "Programmer",
	"Paul Angelo Reyes": "Programmer",
	"Shamma Bergado": "Programmer",
	"Daisy Morcoso": "Programmer",
	"James Malapad": "Programmer",
	"Mary Nicole Noroña": "Programmer",
	"Andrea Donatos": "Programmer",
	"Mikaella Tayoto": "Programmer",
	"Sofia Anne Barrantes": "Programmer",
	"Jasmin Ferolino" : "Programmer",
	"Akisha Santos": "Programmer",
	"Jheann Magtalas": "Programmer"
}

func _ready():
	timer.start(30)
	control.position.y = 1300	
	for i in members:
		print(i)
		var member_name = Label.new()
		var member_role = Label.new()

		member_name.text = i
		member_role.text = members[i]
		grid.add_child(member_name)
		grid.add_child(member_role)
	pass

func _process(_delta):
	control.position.y -= 1

func _input(event):
	if Input.is_action_just_pressed("enter"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().change_scene_to_file.call_deferred("res://src/menu/scene.tscn")

func _on_timer_timeout():
	fade.play("fade_out")
