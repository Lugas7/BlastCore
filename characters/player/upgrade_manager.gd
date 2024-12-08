extends Node

const upgradeList = preload("res://upgradeList.gd")
var upgrades: Dictionary

var player
var msm
var dashState
var cannon
var sword

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for u in upgradeList.UpgradeList:
		upgrades[u] = false
		
	player = get_parent()
	
	msm = player.get_node("Movement State machine")
	dashState = msm.get_node("DashState")
	
	cannon = player.get_node("Gun")
	sword = player.get_node("Sword")


func activate_upgrade(u: String):
	upgrades[u] = true
	
	match u:
		upgradeList.u_big_bullets:
			cannon.BulletScale = cannon.BulletScale_u
		
		upgradeList.u_fast_shot:
			cannon.ReloadTime = cannon.ReloadTime_u
			
		upgradeList.u_bullet_bounce:
			cannon.BulletBounce = true
			
		upgradeList.u_fast_bullets:
			cannon.BulletSpeed = cannon.BulletSpeed_u
			
		upgradeList.u_big_sword:
			sword.swordScale = sword.swordScale_u
			
		upgradeList.u_fast_swing:
			sword.slashCD = sword.slashCD_u
			
		upgradeList.u_fast_dash:
			dashState.dashSpeed = dashState.dashSpeed_u
			dashState.dashTime = dashState.dashTime_u
			dashState.dashTimeout = dashState.dashTimeout_u
			