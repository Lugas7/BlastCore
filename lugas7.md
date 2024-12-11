This is the file for Lucas Martin Thomaz with candidate ID (10008)
the code overview video can be found in the url below, in adition to being in zip file
https://www.dropbox.com/scl/fi/9bdt7zbvgdec7m6ujtdxr/lugas7-code-overview-video.mkv?rlkey=yv8ncm21t5yxj0oj2ws1jphe3&st=5v5ghnqg&dl=0

## Workload:
Lucas:
Player: All
Minimap: All
SwirlEnemy: All
CannonEnemy: All
Bullet: All
Sword: All
Gun: All
Boss: All
World generation (room placement): Some (implemented connecting adjacent rooms, also made game reload after finish)
Rooms: some+ (made new rooms that utilize different enemies and layouts, implemented unique boss logic for finishing the game)

following characters made by Kristian, but implemented within the larger game by Lucas e.g. setting the correct layer and masks as well as making the characters work as enemies for the rooms they are used in.
aoe_elite_enemy: Some
light_dash_enemy: Some
## Reflection
### Bad code:
sword slash state (slash_state.gd), it should be more modular by having the slash position set in it's usage instead of mouse position being tested within the slash state. This could be remediated by having the slash() method in Sword take in an angle as parameter and set a field parameter equal to the angle parameter, then this angle parameter could be accessed in the slash state. This would allow non players with swords to utilize the swords slash functionality. Though I found no use for the slash functionality outside player so no remediation means were taken.

We should have utilized an enemy class instead of simply setting the signal enemy_died multiple times. Each enemy could have extended our enemy class

The manager (manager.gd) is too large of a monolith and should have been partitioned into smaller modules. Even within the manager.gd script.
I am largely happy with the implementation of the sword scene and gun scene as they are reusable in different characters, as they are used in both the player and the enemy. (Though one teammate made his own implementation of a gun/cannon scene for his enemy: aoe_elite_enemy which was unnecessary, another bullet scene was also made)

Another mistake in my code was to connect change in health component to health bar through the character, when this could have been done directly to both save resources and reduce complexity.


## Learning outcome
I learned a great deal of a programming workflow I was unfamiliar with through programing in this godot game engine. I learned asynchronous logic and frame based function logic that was very interesting and new to the traditional sequential programs I am familiar with from earlier courses and projects. One instance of this is when I tried to implement a slash attack for my player that would move a sword 90 degrees in a circle. What I was used to earlier for solving such problems would be something like finding a function that holds the thread for the time until the slash is completed. However in godot I you must implement logic that is updated each frame for such problems. What I did was find a value for how many radians to rotate per second, then rotate the sword by my rotations per second value multiplied by the amount of seconds passed since last frame, this is done using the delta value. This is better than a function that holds the attention of the sequence with say a time.sleep between each rotation as it is more modular by having a function that activates each frame. This way the game engine can calculate as many frames per second as possible allowing for more dynamic slashes depending on the resources available. I also implemented similar logic for other implementations such as the health bar.

Another portion that I learned was signal handling and activating functionality for different components of the game asynchronously e.g. collisions.

