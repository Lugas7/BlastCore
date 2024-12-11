extends Node2D

const Rooms = preload("res://room_class.gd")
const roomMinimapSize = 512


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
	addRoomsToMinimap(currentRoom, Vector2(0, 0))
	position_camera_to_fit_rooms()
	highlight_sprite(currentRoom.sprite)

var numberOfRoomsInMinimap = 0
var visited_rooms = {}
var placed_rooms = []  # Track placed rooms with their positions
@onready var subViewPort = self.get_node("SubViewport")
# adds rooms to minimap recursively from the room provided
func addRoomsToMinimap(room, roomPosition = Vector2(0, 0)):
	if room and not visited_rooms.has(room):  # Avoid duplicate visits
		visited_rooms[room] = true

		# Get SubViewport
		
		# Add the room's sprite to the SubViewport
		room.sprite.name = str(numberOfRoomsInMinimap)
		room.sprite.position = roomPosition

		# make all rooms have the same largest dimension by scaling based on the largest dimension
		if room.sprite.texture.get_size().x > room.sprite.texture.get_size().y:
			var scaleFactor = roomMinimapSize/room.sprite.texture.get_size().x # x is largest length
			room.sprite.scale = Vector2(scaleFactor, scaleFactor) 
		else:
			var scaleFactor = roomMinimapSize/room.sprite.texture.get_size().y # y is largest length
			room.sprite.scale = Vector2(scaleFactor, scaleFactor) 
		
		# Add sprite to viewport and track its position
		subViewPort.add_child(room.sprite)
		placed_rooms.append({"sprite": room.sprite, "position": roomPosition, "room": room})

		numberOfRoomsInMinimap += 1
		
		# Check and connect adjacent rooms
		connect_neighbors_if_adjacent(room, roomPosition)

		# Iterate through the neighbors
		for i in range(len(room.Neighboors)):
			if room.Neighboors[i]:  # Check if a neighbor exists
				var neighbor = room.Neighboors[i]
				var new_position = roomPosition
				
				# Calculate position based on the direction
				match i:
					0:  # Right
						new_position = Vector2(roomPosition.x + roomMinimapSize, roomPosition.y)
					1:  # Up
						new_position = Vector2(roomPosition.x, roomPosition.y - roomMinimapSize)
					2:  # Left
						new_position = Vector2(roomPosition.x - roomMinimapSize, roomPosition.y)
					3:  # Down
						new_position = Vector2(roomPosition.x, roomPosition.y + roomMinimapSize)
				
				# Recursive call for the neighbor
				addRoomsToMinimap(neighbor, new_position)

func position_camera_to_fit_rooms():
	var camera = $SubViewport/Camera2D

	# Step 1: Initialize extreme values for the room bounds
	var min_x = INF
	var max_x = -INF
	var min_y = INF
	var max_y = -INF

	# Step 2: Calculate the bounds of all placed rooms
	for placed in placed_rooms:
		var sprite_global_position = placed["sprite"].global_position
		var sprite_size = Vector2(placed["sprite"].texture.get_width(), placed["sprite"].texture.get_height())

		# Update bounds based on global positions
		min_x = min(min_x, sprite_global_position.x)
		max_x = max(max_x, sprite_global_position.x + sprite_size.x)
		min_y = min(min_y, sprite_global_position.y)
		max_y = max(max_y, sprite_global_position.y + sprite_size.y)

	# Step 3: Set the camera limits
	camera.set_position(Vector2(max_x, max_y))

# function connects neighboring rooms by updating their Neighbor array, is based on the proximity of the room sprites in the minimap
func connect_neighbors_if_adjacent(current_room, current_position):
	for placed in placed_rooms:
		var placed_room = placed["room"]
		var placed_position = placed["position"]

		# Check adjacency on all sides
		if placed_position.x == current_position.x + roomMinimapSize and placed_position.y == current_position.y:
			# Current room's right side aligns with the placed room's left side
			current_room.Neighboors[0] = placed_room
			placed_room.Neighboors[2] = current_room
		elif placed_position.x == current_position.x - roomMinimapSize and placed_position.y == current_position.y:
			# Current room's left side aligns with the placed room's right side
			current_room.Neighboors[2] = placed_room
			placed_room.Neighboors[0] = current_room
		elif placed_position.y == current_position.y - roomMinimapSize and placed_position.x == current_position.x:
			# Current room's top aligns with the placed room's bottom
			current_room.Neighboors[1] = placed_room
			placed_room.Neighboors[3] = current_room
		elif placed_position.y == current_position.y + roomMinimapSize and placed_position.x == current_position.x:
			# Current room's bottom aligns with the placed room's top
			current_room.Neighboors[3] = placed_room
			placed_room.Neighboors[1] = current_room


			#dir = 0  # Right
		#"DoorUp":
			#dir = 1  # Up
		#"DoorLeft":
			#dir = 2  # Left
		#"DoorDown":
			#dir = 3  # Down


# highlights sprite of room by darkening it, if shouldBeHighlighted is false it removes the darkening
func highlight_sprite(sprite: Sprite2D, shouldBeHighlighted: bool = true) -> void:
	# Define the tint colors
	var highlight_tint = Color(0.8, 0.8, 0.8, 1) # Slightly darker tint
	var default_tint = Color(1, 1, 1, 1) # Original tint

	if shouldBeHighlighted:
		# Apply the darker tint
		sprite.modulate = highlight_tint
	else:
		# Revert to the original tint
		sprite.modulate = default_tint


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# called on enemy died, unlocks doors if all enemies died, and for boss room clears the game
func _on_enemy_died():
	enemies_left -= 1
	#print("enemy died, enemies left: ", enemies_left)
	if !currentRoom.Cleared:
		if(enemies_left) == 0:
			if currentRoom.Type == "boss":
				await get_tree().create_timer(1).timeout # timer to allow player to see the boss defeated
				OS.alert("You beat the game, click ok to restart, upgrades will remain", "Success!")
				restartGameWhileRetainingUpgrades()
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

# generates level and gives each room a sprite based on the _sprite.png ending file with same name as *.tscn
func generateLevel(length: int) -> Rooms.Room:
	var lastRoom = generateLayout(length)
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	var allRooms = lastRoom.allRooms()
	
	var availableUpgrades = preload("res://upgradeList.gd").UpgradeList.duplicate()
	#print(availableUpgrades)
	availableUpgrades.shuffle()
	#print(availableUpgrades)
	
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
			var filteredFiles = []
			# removing files that don't end with .tscn to remove e.g. .png files
			for file in files:
				if file.ends_with(".tscn"):
					filteredFiles.append(file)
			var rIndex = rng.randi_range(0, len(filteredFiles)-1)
			var file = filteredFiles[rIndex]
			r.RoomFile = path + "/" + file
			r.sprite = Sprite2D.new()
			# loads image with path for room: sampleRoom.tscn -> sampleRoom_sprite.png
			var image = Image.load_from_file(path + "/" + file.replace(".tscn", "") + "_sprite.png")
			if !image: # sprite image path is most likely not the standard
				OS.alert("Image failed to load with expected path: " + path + "/" 
				+ file.replace(".tscn", "") + "_sprite.png", "ALERT")
			else:
				var texture = ImageTexture.create_from_image(image)
				if not texture:
					print("Texture creation failed!")
				else:
					r.sprite.texture = texture


	
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
	print("Before and after highlighting")
	print(currentRoom.sprite.scale)
	highlight_sprite(currentRoom.sprite, false)
	print(currentRoom)
	print(currentRoom.Neighboors[dir])
	currentRoom = currentRoom.Neighboors[dir]
	highlight_sprite(currentRoom.sprite, true)
	print(currentRoom.sprite.scale)

	loadRoom(currentRoom, dir)

# loads another scene of world (the root node of the game) and sets the upgrades equal to current scenes upgrades
# then replaces the root scene with the newly generated world, then que frees current node.
func restartGameWhileRetainingUpgrades():
	var new_scene = preload("res://world.tscn").instantiate()
	for upgradeKeyString in playerUpgradeManager.upgrades.keys():
		if playerUpgradeManager.upgrades[upgradeKeyString]:
			print("persistent upgrade kept: " + upgradeKeyString)
			new_scene.get_node("Player").get_node("UpgradeManager").activate_upgrade(upgradeKeyString)
	get_tree().root.add_child(new_scene)  # Add the new scene
	queue_free()  # Free the current scene

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
			
