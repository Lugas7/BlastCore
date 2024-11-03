extends Node2D
class_name Sword

var slashSpeed = 0.3
const slashCD = 0.5
var slashCDLeft = slashCD

@export var stateMachine: StateMachine
@export var slashState: SlashState

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	slashCDLeft -= delta

func slash():
	if slashCDLeft <= 0:
		slashCDLeft = slashCD
		stateMachine._on_state_transition("SlashState", null)
