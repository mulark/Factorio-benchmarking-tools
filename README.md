The intent of this repo is to provide a useful scratchpad for maps, scripts, and commands that assist in the overall benchmarking process.

Items of note in the repo:
* cloner.lua: A script to automagically copy all the entities in one area to another. This will be maintained for 0.16.x releases, in 0.17.x a new version will be written
* maps: a folder containing some past map tests and benchmarks. Future maps and benchmarks will be uploaded to https://mulark.github.io
* factorio_lua_commands.lua: a lot of basic commands that I have used to bend the game state to my will. If a particular command in this file becomes big or useful enough it will be split into a new file exclusively for it.
* inserter_primer.lua: a lua script to evaluate every inserter in the map. If the inserter needs to be primed, the script will attempt to prime it.
* profile_benchmark.sh: A bash script to automatically run a callgrind profile on a number of maps which match a $pattern
* offshore_placer.lua: A lua script that automatically replaces the current water infrastructure of a map into one that directly puts water offshores where needed.
