#!/bin/bash 

pattern="test-000009"
ticks=100
IFS=$'\n'

for map in $(ls -1p ../../saves | grep -Zv / | grep "$pattern")
    do
        echo "$map"
        valgrind --tool=callgrind --callgrind-out-file=""$map"_$(date +%s).kcachegrind" --toggle-collect="Scenario::update()" ./factorio --benchmark "$map" --benchmark-ticks $ticks
    done

