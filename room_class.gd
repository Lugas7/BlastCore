extends Node


# A graph based representation of the rooms
class Room:
	var Type: String
	var RoomFile: String
	var X: int
	var Y: int
	
	# Neighbooring rooms
	var Neighboors: Array
	var Cleared: bool
	
	static func create(type: String, x: int, y: int) -> Room:
		var room = Room.new()
		room.Type = type
		room.X = x
		room.Y = y
		
		room.Neighboors = [null, null, null, null]
		room.Cleared = false
		
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
			for i in range(4):
				var r = currentRoom.Neighboors[i]
				if r && r not in visited:
					stack.append(r)
		
		return visited
	
	# Create a new room that neighboors this room
	func newRoom(dir: int, x: int, y: int, type: String) -> Room:
		var newRoom: Room 
		
		Neighboors[dir] = Room.create(type, x, y)
		var oppositeDir = (dir + 2) % 4
		Neighboors[dir].Neighboors[oppositeDir] = self

		return Neighboors[dir]
