extends Node2D

const Rooms = preload("res://room_class.gd")

var currentRoom
var roomInstance

var player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = self.get_node("Player")
	
	var lastRoom = generateLevel(8)
	
	var rooms = lastRoom.allRooms()
	for r in rooms:
		if r.Type == "start":
			currentRoom = r
			loadRoom(r, 0)
			break
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if !currentRoom.Cleared:
		# Check how many enemies are left
		var enemies =  get_tree().get_nodes_in_group("Enemy")
		if(len(enemies)) == 0:
			print("Cleared")
			currentRoom.Cleared = true
			
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
	
	# Assign a file for each room
	for r in allRooms:
		var path = "rooms/1/"+r.Type
		var dir = DirAccess.open(path)
		if dir:
			var files = dir.get_files()
			var rIndex = rng.randi_range(0, len(files)-1)
			var file = files[rIndex]
			r.RoomFile = path + "/" + file
	
	return lastRoom


func generateLayout(length: int) -> Rooms.Room:
	var size = length * 2
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
				if (r != 0 && r != size-1) && rng.randi_range(0, 1)==1:
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
	if len(sideRooms) < length/3:
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
	var allRooms = room.allRooms()
	
	for r in allRooms:
		r.Neighboors = []
		r = null


func nextRoom(dir: int):
	currentRoom = currentRoom.Neighboors[dir]
	loadRoom(currentRoom, dir)


# Load a room
func loadRoom(room: Rooms.Room, fromDir: int):
	
	# Remove all projectiles from the previous room
	var playerProjectiles =  get_tree().get_nodes_in_group("Player_projectile")
	for p in playerProjectiles:
		p.queue_free()
	
	# Remove the previous room
	if roomInstance:
		roomInstance.queue_free()
	
	# Load the room
	var roomScene = load(room.RoomFile)
	roomInstance = roomScene.instantiate()
	self.add_child(roomInstance)
	
	# Remove previous camera
	var prevCam = player.get_node("Camera2D")
	if prevCam:
		player.remove_child(prevCam)
	
	# Set the camera to follow the player
	var camera = roomInstance.get_node("Camera2D")
	roomInstance.remove_child(camera)
	player.add_child(camera)
	camera.enabled = true

	var directions = ["Right", "Up", "Left", "Down"]
	for i in range(4):
		
		# Spawn the player at the the door
		if i == fromDir:
			var spawnPoint = roomInstance.get_node("DoorSpawn" + directions[i])
			player.position = spawnPoint.position
			camera.global_position = player.position
			
			player.set_collision_layer(1)
			player.set_collision_mask(1)
		
		
		# Delete the doors to non-existent rooms, or se
		var doorName = "Door" + directions[i]
		var door = roomInstance.get_node(doorName)
		
		if !room.Neighboors[i]:
			door.queue_free()
