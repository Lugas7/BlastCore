extends Node2D

var area2d: Area2D

var upgrade: String
var price: int

@onready var label = $Label


func _ready() -> void:
	label.text = upgrade
	

signal upgrade_bought
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		var player = body
		
		if player.gold >= price:
			player.gold -= price
			player.upgrades[upgrade] = true
			print(upgrade)
			emit_signal("upgrade_bought")
			queue_free()
			
