extends ProgressBar
class_name HealthBar

@onready var timer = $Timer
@onready var damage_bar = $DamageBar

var tickingPercentLeft = 0 # neccesary to make delay before damagePercent goes down
const percentTickPerSecond = 20
const timeOutBeforeBeginTickingDamageBar = 1

func setPercent(newPercent):
	#print("new Percent: " + str(newPercent))
	var changePercent = value - newPercent
	value = newPercent
	if changePercent > 0:
		# delayed tickingPercent addition, setPercent can still be called while the sleeps in different thread
		await get_tree().create_timer(timeOutBeforeBeginTickingDamageBar).timeout
		tickingPercentLeft += changePercent 
	else:
		damage_bar.value = damage_bar.value # healing so damage should be same place as health

func _ready():
	value = 100.0
	damage_bar.value = 100.0



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if value == 100:
		visible = false
		damage_bar.visible = false
	else:
		visible = true
		damage_bar.visible = true
	
	if tickingPercentLeft >= 0:
		var howManyPercentToTickThisFrame = percentTickPerSecond*delta
		# both values have to be updated
		tickingPercentLeft -= howManyPercentToTickThisFrame
		damage_bar.value -= howManyPercentToTickThisFrame
