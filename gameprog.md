Our github repo link:
https://github.com/Lugas7/BlastCore

## Team Members
Lucas Martin Thomaz (lugas7 on github, sometimes appear as foobar123asdf since configured email to be my@email.com) (CandidateID: 10008)
Fredrik Grøttås (fredgrot on github)
Lucas Martin Thomaz
Thomas R. (Elthel1 on github)
Kristian Sjåberg Hartvigsen (KristianHar on github) (10037)

The public github repo can be found:
https://github.com/Lugas7/BlastCore/tree/main
## Development process
### GODOT Strengths 
- Free and open source: Godot is both free and open source, removing any barrier to entry for the group members. 
- Flexible & easy scene system: Godot's node-based style is not too difficult to learn and let us create more complex game elements easier by beilg able to build and reuse different parts of the game.
- GDScript: Godot has its own scripting language which is easy to pick up and works well with the engine.
- Great for 2D and 3D games: although Blastcore is a 2D game, godot has strong tools for handling 2D graphics, animations and physics.
- Good community and a lot of resouces: The engine has an active community and relatively good communicaiton.

### GODOT Weaknesses
- Initial difficulty: At first managing different nodes and scenes and combining/integrating them to create a game can be difficult.
- Hard to learn more advanced features: While the system and GDscript language might be "easy" to pick up initially, more complex parts of the engine can be difficult to understand.
- Performance: Not necessarily a major factor in our project but in general Godot is known for not being the engine at the top of the optimization list, or at least being known for requiring more extensive manual optimization than some other engines. 

### Communication systems during development & version control systems
We developed using git and utilized the kanban board with issues assigned to different team members, though in the later stages of development this was not utilized further as some members stopped meeting in group meetings and work began more independently. 
We utilized branches by creating feature branches for each feature we were tasked with developing we would then first update the feature branch from the main branch before merging the feature branch back in to main. 

We had many shortcomings in our process. One did not utilize a strict naming convention both for following godots standard for naming functions as we used sampleFunction instead of sample_function. Another instance of this is with the naming of our nodes, scenes and variable names. One instance of inconsistent naming is that the gun is sometimes referred to as cannon.

Another limitation of our teamwork is that due to misunderstanding documentation sometimes modules created by other teammates were misused by another teammate that misunderstood how it should be used.

If we had planned better as a team for how to build our videogame with both better collaboration and better planning much of our issues could have been resolved.

### Practices that could have improved our workflow
Implemented code reviews, if we utilized the collaboration features in git more properly from the start we could have tied different issues to relevant branches and had peer-reviews to give feedback/squash bugs before merges generating a better but also more secure overall workflow. 

One way to improve the problems of communication and planning are in person meetings where we can get to know each other better. With in person meetings it can be easier to understand each persons goals and ideas for the game so that we could allocate responsibilities better.

Another way we could have improved our workflow is to have made and designed uml diagrams for how our game should be structured. It would be useful to know each module beforehand decided as a group. By doing this we would both improve our ability to allocate work as well as standardize naming. 

Another important benefit from having designed a uml diagram is that it could help our team understand how to use each others components properly. During our process components made by one team member were used incorrectly by another. One example of this is one team member calling the health bar set property function directly instead of the tailor made function. In this case this resulted in the health bar being modified but the damage bar not being ticked down with time as expected.
