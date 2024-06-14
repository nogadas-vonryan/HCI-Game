extends Interactable


@onready var animation = $AnimationPlayer
var isOpen = false

func _ready():
	type = "Closet"
	message = "Press [E] to open"

func interact():
	if isOpen:
		isOpen = false
		animation.play("close_door")
	else:
		isOpen = true
		animation.play("open_door")
		if name == "surprise_closet":
			Global.getRoot().get_node("Enemies").get_node("skinny_zombie2").follow = true
