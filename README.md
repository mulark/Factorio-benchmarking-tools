The intent of this repo is to provide a useful scratchpad for maps, scripts, and commands that assist in the overall benchmarking process. 

Items of note in the repo: 
* cloner.lua: A script to automagically copy all the entities in one area to another.
* maps: a folder containing some past map tests and benchmarks. Future maps and benchmarks will be uploaded to https://mulark.github.io
* useful_commands.lua: a lot of basic commands that I have used to bend the game state to my will. If a particuar command in this file becomes big or useful enough it will be split into a new file exclusively for it.


Legacy stuff below:

**Naming Schema:**
* {category shortname}.{design number}.{minor revision}
  * redsci.v1.0

Description should be added to the category description file, describing the general design.

More categories and maps by suggestion

**Generic RULES:**
* Mining productivity can be any level desired less than 10,000 (as there is negative scaling the higher you go, belts are more affected than chests, for instance) and Worker robots speed 25 may not increased further.
* You may use landfill.
* You may extend the resources or water further to the north or south as needed for designs (oil must remain the same richness), but not east or west. You may not use resources outside the vertical columns of resources.
* Pollution must remain disabled.
* Biters must remain disabled.
* If trains are used, you may not use vertical train stations on the resource patches themselves (since in the game, there are no resources patches that can be hundreds of chunks long). Horizontal stations are allowed, but must be limited to one resource per train stop. Multiple stops can be used for 1 train and many resources.
* Factorio version 0.16.51 or any later stable 0.16 version may be used. 0.17 will be evaluated when it is released. 
* You may use the vanilla infinity chest to void the final product. The 6-Science category must be researching worker robots speed, no voiding may be used in this category.
* You may not used the infinity chest to create items for any of the science categories. They must be mined and processed.
* In general, if it is possible in vanilla, it is allowed.
 
