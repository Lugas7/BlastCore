extends Node

class Room:
	var Type: String
	var X: int
	var Y: int
	
	var Left: Room
	var Right: Room
	var Up: Room
	var Down: Room
	
	static func create(type: String, x: int, y: int) -> Room:
		var room = Room.new()
		room.Type = type
		room.X = x
		room.Y = y
		
		return room
		
	func allRooms() -> Array[Room]:
		var visited: Array[Room]
		var stack = [self]
		
		while stack.size() > 0:
			var currentRoom = stack.pop_back()
			
			if currentRoom in visited:
				continue
				
			visited.append(currentRoom)
				
			# Check each neighboor room
			if currentRoom.Right and currentRoom.Right not in visited:
				stack.append(currentRoom.Right)
			if currentRoom.Left and currentRoom.Left not in visited:
				stack.append(currentRoom.Left)
			if currentRoom.Up and currentRoom.Up not in visited:
				stack.append(currentRoom.Up)
			if currentRoom.Down and currentRoom.Down not in visited:
				stack.append(currentRoom.Down)
		
		return visited
		
	func newRoom(dir: int, x: int, y: int, type: String) -> Room:
		var newRoom: Room 
		match dir:
			0: # Right
				Right = Room.create(type, x, y)
				Right.Left = self
				newRoom = Right
			1: # Up
				Up = Room.create(type, x, y)
				Up.Down = self
				newRoom = Up
			2: # Left
				Left = Room.create(type, x, y)
				Left.Right = self
				newRoom = Left
			3: # Down
				Down = Room.create(type, x, y)
				Down.Up = self
				newRoom = Down
		return newRoom
		




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	generateLevel(5)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func generateLevel(length: int):
	var lastRoom = generateLayout(length)
	var rooms = lastRoom.allRooms()
	
	for r in rooms:
		print(r.X, ", ", r.Y, ": ", r.Type)
	


func generateLayout(length: int) -> Room:
	var size = 10
	var emptyRow: Array[bool]
	var freeTiles: Array[Array]
	
	emptyRow.resize(size)
	freeTiles.resize(size)
	
	emptyRow.fill(true)
	for i in range(size):
		freeTiles[i] = emptyRow.duplicate()
	
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	var parentRoom = Room.create("Start", size/2, size/2)
	freeTiles[size/2][size/2] = false
	
	# There can be one special room (loot or shop) per level
	var placedSpecialRoom = false
	
	# Create the room layout
	for r in range(length):
		
		while true:
			var dir = rng.randi_range(0, 3)
			
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
				var type = "Normal"
				if r == length-1:
					type = "Boss"
				
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
						type = "Normal"
						if !placedSpecialRoom && rng.randi_range(0, 1)==1:
							type = "Special"
							placedSpecialRoom = true
							
						newRoom.newRoom(dir, newX, newY, type)
							
						# Mark as occupied
						freeTiles[newY][newX] = false
				
				break
				
	return parentRoom
