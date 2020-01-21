#!/bin/bash

# Intended for use with factorio-benchmark-helper's results.db file
# Interim solution until proper dumping is added to it.

> pivot.sql

sqlite3 results.db "select * from collection;"
echo "Enter a collection_id to dump data. Default: [most recent]"
read collection_id

case $collection_id in
    [0-9]*)
        ;;
    *)
        collection_id=$(sqlite3 results.db "select max(collection_id) from collection;")
        echo "collection_id $collection_id selected"
        ;;
esac

echo "Please specify function to aggregate data on (avg, [min], max)"
read operation

case $operation in
	avg)
		operation="avg"
		;;
	min)
		operation="min"
		;;
	max)
		operation="max"
		;;
	*)
		operation="min"
		;;
esac


echo "Please specify which metrics to dump ([wholeUpdate], all)"
read timing

case $timing in
	all)
		timing="all"
		;;
	*)
		timing="wholeUpdate"
		;;
esac

#ids_to_collect=$(cat ids_to_collect)
#ids_to_collect=$(sqlite3 test.db "select benchmark_id from test;" | sort | uniq)
ids_to_collect=$(sqlite3 results.db "select benchmark_id from benchmark where collection_id = $collection_id")
if [[ ${#ids_to_collect} == 0 ]] ; then
	echo "No ids specified"
	exit 1
fi

> pivot.sql

initial="true"
for benchmark_id in $ids_to_collect ; do
    map_name=$(sqlite3 results.db "select map_name from benchmark where benchmark_id = $benchmark_id")
	if [[ $initial == "true" ]] ; then
		printf "SELECT id${benchmark_id}.tick_number,"
		initial="false"
	fi
    printf "id${benchmark_id}.wholeUpdate as [$map_name.wholeUpdate],"
    if [[ $timing == "all" ]] ; then
        printf ", id${benchmark_id}.gameUpdate as [$map_name.gameUpdate],"
        printf "id${benchmark_id}.circuitNetworkUpdate as [$map_name.circuitNetworkUpdate],"
        printf "id${benchmark_id}.transportLinesUpdate as [$map_name.transportLinesUpdate],"
        printf "id${benchmark_id}.fluidsUpdate as [$map_name.fluidsUpdate],"
        printf "id${benchmark_id}.entityUpdate as [$map_name.entityUpdate],"
        printf "id${benchmark_id}.mapGenerator as [$map_name.mapGenerator],"
        printf "id${benchmark_id}.electricNetworkUpdate as [$map_name.electricNetworkUpdate],"
        printf "id${benchmark_id}.logisticManagerUpdate as [$map_name.logisticManagerUpdate],"
        printf "id${benchmark_id}.constructionManagerUpdate as [$map_name.constructionManagerUpdate],"
        printf "id${benchmark_id}.pathFinder as [$map_name.pathFinder],"
        printf "id${benchmark_id}.trains as [$map_name.trains],"
        printf "id${benchmark_id}.trainPathFinder as [$map_name.trainPathFinder],"
        printf "id${benchmark_id}.commander as [$map_name.commander],"
        printf "id${benchmark_id}.chartRefresh as [$map_name.chartRefresh],"
        printf "id${benchmark_id}.luaGarbageIncremental as [$map_name.luaGarbageIncremental],"
        printf "id${benchmark_id}.chartUpdate as [$map_name.chartUpdate],"
        printf "id${benchmark_id}.scriptUpdate as [$map_name.scriptUpdate],"

    fi
done | sed 's/,$//' >> pivot.sql

printf " FROM\n" >> pivot.sql

for benchmark_id in $ids_to_collect ; do
	printf "(SELECT tick_number,${operation}(wholeUpdate) /1000000.0 as wholeUpdate "
    if [[ $timing == "all" ]] ; then
        printf ", ${operation}(gameUpdate) /1000000.0 as [gameUpdate],"
        printf "${operation}(circuitNetworkUpdate) /1000000.0 as [circuitNetworkUpdate],"
        printf "${operation}(transportLinesUpdate) /1000000.0 as [transportLinesUpdate],"
        printf "${operation}(fluidsUpdate) /1000000.0 as [fluidsUpdate],"
        printf "${operation}(entityUpdate) /1000000.0 as [entityUpdate],"
        printf "${operation}(mapGenerator) /1000000.0 as [mapGenerator],"
        printf "${operation}(electricNetworkUpdate) /1000000.0 as [electricNetworkUpdate],"
        printf "${operation}(logisticManagerUpdate) /1000000.0 as [logisticManagerUpdate],"
        printf "${operation}(constructionManagerUpdate) /1000000.0 as [constructionManagerUpdate],"
        printf "${operation}(pathFinder) /1000000.0 as [pathFinder],"
        printf "${operation}(trains) /1000000.0 as [trains],"
        printf "${operation}(trainPathFinder) /1000000.0 as [trainPathFinder],"
        printf "${operation}(commander) /1000000.0 as [commander],"
        printf "${operation}(chartRefresh) /1000000.0 as [chartRefresh],"
        printf "${operation}(luaGarbageIncremental) /1000000.0 as [luaGarbageIncremental],"
        printf "${operation}(chartUpdate) /1000000.0 as [chartUpdate],"
        printf "${operation}(scriptUpdate) /1000000.0 as [scriptUpdate]"
    fi
    printf "from verbose where benchmark_id = $benchmark_id group by tick_number) as id${benchmark_id},\n"
done | sed '$s/,$//' >> pivot.sql

first="true"
first_id=$(echo "$ids_to_collect" | head -n1 | awk '{print $1}')
last_id=$(echo "$ids_to_collect" | tail -n1 | awk '{print $1}')
echo $last_id
# Don't redirect to pivot inside this loop
for benchmark_id in $ids_to_collect ; do
	if [[ $first == "true" && $first_id != $last_id ]] ; then
		printf "WHERE "
		first="false"
	fi
	if [[ $first_id != $benchmark_id ]] ; then
		printf "id${first_id}.tick_number = id${benchmark_id}.tick_number "
        if [[ $last_id != $benchmark_id ]] ; then
            printf "AND "
        fi
	fi
done >> pivot.sql

printf ";\n" >> pivot.sql

echo "Genereated SQL to pivot.sql, running query."

cat pivot.sql | sqlite3 results.db -cmd ".mode csv" -cmd ".headers on" > data.csv

echo "Finished query. Data in data.csv"
