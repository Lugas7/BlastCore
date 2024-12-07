extends Node2D

const Rooms = preload("res://room_class.gd")

var roomCount = 5

var player
var playerUpgradeManager
var camera

var currentRoom
var roomInstance

var enemies_left = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = self.get_node("Player")
	playerUpgradeManager = player.get_node("UpgradeManager")
	camera = player.get_node("Camera")
	
	var lastRoom = generateLevel(roomCount)
	
	var rooms = lastRoom.allRooms()
	for r in rooms:
		if r.Type == "start":
			r.Cleared = true
			currentRoom = r
			loadRoom(r, 0)
		elif r.Type == "special":
			r.Cleared = true
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_enemy_died():
	enemies_left -= 1
	print("enemy died, enemies left: ", enemies_left)
	if !currentRoom.Cleared:
		if(enemies_left) == 0:
			currentRoom.Cleared = true
			unlockDoors()

func _on_upgrade_bought(upgrade: String):
	playerUpgradeManager.activate_upgrade(upgrade)
	currentRoom.UpgradeTaken = true

func unlockDoors():
	if currentRoom.Cleared:
		# Unlock the doors
		var doors = get_tree().get_nodes_in_group("Door")
		for d in doors:
			d.locked = false
			var doorSprite = d.get_node("Sprite2D")
			doorSprite.texture = load("res://assets/door.png")


func generateLevel(length: int) -> Rooms.Room:
	var lastRoom = generateLayout(length)
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	var allRooms = lastRoom.allRooms()
	
	var availableUpgrades = preload("res://upgradeList.gd").UpgradeList.duplicate()
	print(availableUpgrades)
	availableUpgrades.shuffle()
	print(availableUpgrades)
	
	# Assign a file for each room
	for r in allRooms:
		# Assign an upgrade if the room is special
		if r.Type == "special":
			var upgrade = availableUpgrades[0]
			availableUpgrades.remove_at(0)
			
			r.Upgrade = upgrade
			r.UpgradeTaken = false
			r.UpgradePrice = 100
		else:
			r.Upgrade = ""
			r.UpgradeTaken = true
			r.UpgradePrice = 0
		
		var path = "res://rooms/1/"+r.Type
		var dir = DirAccess.open(path)
		if dir:
			var files = dir.get_files()
			var rIndex = rng.randi_range(0, len(files)-1)
			var file = files[rIndex]
			r.RoomFile = path + "/" + file
	
	return lastRoom


func generateLayout(length: int) -> Rooms.Room:
	var size = length * 3
	var emptyRow: Array[bool]
	var freeTiles: Array[Array]
	
	emptyRow.resize(size)
	freeTiles.resize(size)
	emptyRow.fill(true)
	for i in range(size):
		freeTiles[i] = emptyRow.duplicate()
	
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	var parentRoom = Rooms.Room.create("start", size/2, size/2)
	#parentRoom.Cleared = true
	freeTiles[size/2][size/2] = false
	
	# Create the room layout
	for r in range(length):
		
		# List of all attempted directions
		var triedDirections = []
		
		while true:
			# Try again if there is a dead end
			if len(triedDirections) == 4:
				destroyRooms(parentRoom)
				return generateLayout(length)
			
			var dir = rng.randi_range(0, 3)
			
			if dir not in triedDirections:
				triedDirections.append(dir)
			else:
				continue
			
			var addX = 0
			var addY = 0
			
			var newRoom
			
			match dir:
				0: # Right
					addX = 1
				1: # Up
					addY = -1
				2: # Left
					addX = -1
				3: # Down
					addY = 1
			
			var newX = parentRoom.X + addX
			var newY = parentRoom.Y + addY
			
			# Create a new room if it is free and in bounds
			if freeTiles[newY][newX] && newX < size && newX >= 0 && newY < size && newY >= 0:
				var type = "normal"
				if r == length-1:
					type = "boss"
				
				newRoom = parentRoom.newRoom(dir, newX, newY, type)
				parentRoom = newRoom
				
				# Mark as occupied
				freeTiles[newY][newX] = false
				
				# Maybe place a side room
				if type != "boss" && (r != 0 && r != size-1) && rng.randi_range(0, 1)==1:
					dir = rng.randi_range(0, 3)
						
					addX = 0
					addY = 0
						
					match dir:
						0: # Right
							addX = 1
						1: # Up
							addY = -1
						2: # Left
							addX = -1
						3: # Down
							addY = 1
						
					newX = newRoom.X + addX
					newY = newRoom.Y + addY
						
					# Create the side room
					if newX < size && newX >= 0 && newY < size && newY >= 0 && freeTiles[newY][newX]:
						newRoom.newRoom(dir, newX, newY, "side")
						
						# Mark as occupied
						freeTiles[newY][newX] = false
				
				break
	
	var rooms = parentRoom.allRooms()
	
	
	# Ensure that at least a few side rooms were created. If not, try again
	var sideRooms = rooms.filter(func(r): return r.Type == "side")
	if len(sideRooms) < length/2:
		destroyRooms(parentRoom)
		return generateLayout(length)
	
	
	# Turn about half of the side rooms into special rooms (shops, loot etc.)
	sideRooms.shuffle()
	var specialRoomCount: int = len(sideRooms)/2
	for i in range(specialRoomCount):
		sideRooms[i].Type = "special"
		
	print("Side rooms: ", len(sideRooms), ", of which are special rooms: ", specialRoomCount)
	
	# Turn the rest into normal rooms
	sideRooms = rooms.filter(func(r): return r.Type == "side")
	for r in sideRooms:
		r.Type = "normal"
	
	
	return parentRoom


func destroyRooms(room: Rooms.Room):
	var rooms = room.allRooms()
	for r in rooms:
		r.Neighboors = []


func nextRoom(dir: int):
	currentRoom = currentRoom.Neighboors[dir]
	loadRoom(currentRoom, dir)


# Load a room
func loadRoom(room: Rooms.Room, fromDir: int):
	
	# Remove all projectiles from the previous room
	var playerProjectiles =  get_tree().get_nodes_in_group("Player_projectile")
	for p in playerProjectiles:
		p.queue_free()
	
	# Delete the previous room
	if roomInstance:
		roomInstance.queue_free()
	
	# Load the room
	var roomScene = load(room.RoomFile)
	print(room.RoomFile)
	roomInstance = roomScene.instantiate()
	self.add_child(roomInstance)
	
	# Initialize the powerup if special
	if room.Type == "special":
		var upgrade = roomInstance.get_node("Upgrade")
		upgrade.connect("upgrade_bought", _on_upgrade_bought)
		if room.UpgradeTaken:
			upgrade.queue_free()
		else:
			upgrade.upgrade = room.Upgrade
			upgrade.price = room.UpgradePrice
			var label = upgrade.get_node("Label")
			label.text = upgrade.upgrade + "\n " + str(upgrade.price)
		
	
	var enemies = get_tree().get_nodes_in_group("Enemy")
	var enemy_count = len(enemies)
	
	# If there are no enemies it means it is a special room
	if enemy_count == 0:
		room.Cleared = true
	
	if !room.Cleared:
		# If the room is not cleared, listen to enemy death signal
		enemies_left = enemy_count
		for enemy in enemies:
			enemy.connect("enemy_died", _on_enemy_died)
	else:
		# If the room is cleared, remove all enemies and unlock the doors
		for enemy in enemies:
			enemy.queue_free()
		unlockDoors()
	
	# Prepare the camera
	var corner1 = roomInstance.get_node("RoomCorner1").position
	var corner2 = roomInstance.get_node("RoomCorner2").position
	camera.limit_left = corner1.x
	camera.limit_right = corner2.x
	camera.limit_top = corner1.y
	camera.limit_bottom = corner2.y
	
	
	var directions = ["Right", "Up", "Left", "Down"]
	for i in range(4):
		
		# Spawn the player at the the door
		if i == fromDir:
			var spawnPoint = roomInstance.get_node("DoorSpawn" + directions[i])
			player.position = spawnPoint.position
			#player.set_collision_layer(1)
			#player.set_collision_mask(1)
			camera.global_position = player.global_position
		
		
		# Delete the doors to non-existent rooms, or se
		var doorName = "Door" + directions[i]
		var door = roomInstance.get_node(doorName)
		
		if !room.Neighboors[i]:
			door.queue_free()
		else:
			door.visible = true
			
