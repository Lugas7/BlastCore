"""
# Wall
- Connecting (Will be wall if not connecting)
P Player

m Mines
t Tank enemy
"""


var startingRooms = [
	[ # 7*7
		"###-###",
		"#     #",
		"#     #",
		"-  p  -",
		"#     #",
		"#     #",
		"###-###",
	]
]


var bossRoom = [
	[ # 7*7
		"###-###",
		"#     #",
		"#     #",
		"-  p  -",
		"#     #",
		"#     #",
		"###-###",
	]
]

var corridoors = [
	[ # 8*5
		"########",
		"#      #",
		"-      -",
		"#      #",
		"########"
	]
]

var combatRooms = [
	[ # 16*16
		"#######-#######",
		"#             #",
		"# t         t #",
		"#             #",
		"#      m      #",
		"#             #",
		"#             #",
		"-   m     m   -",
		"#             #",
		"#             #",
		"#      m      #",
		"#             #",
		"# t         t #",
		"#             #",
		"#######-#######",
	]
]
