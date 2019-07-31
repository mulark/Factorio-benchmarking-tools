#!/bin/bash

> pivot.sql

echo "Enter a collection_id to dump data. Default: [most recent]"
read collection_id

case $collection_id in
    [0-9]*)
        ;;
    *)
        collection_id=$(sqlite3 test.db "select max(collection_id) from benchmark_collection;")
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

#ids_to_collect=$(cat ids_to_collect)
#ids_to_collect=$(sqlite3 test.db "select benchmark_id from test;" | sort | uniq)
ids_to_collect=$(sqlite3 test.db "select benchmark_id from benchmark_base where collection_id = $collection_id")
if [[ ${#ids_to_collect} == 0 ]] ; then
	echo "No ids specified"
	exit 1
fi

initial="true"
for benchmark_id in $ids_to_collect ; do
    map_name=$(sqlite3 test.db "select map_name from benchmark_base where benchmark_id = $benchmark_id")
	if [[ $initial == "true" ]] ; then
		printf "SELECT id${benchmark_id}.tick_number,"
		initial="false"
	fi
	printf "id${benchmark_id}.wholeUpdate as [$map_name],"
done | sed 's/,$//' >> pivot.sql

printf " FROM\n" >> pivot.sql

for benchmark_id in $ids_to_collect ; do
	printf "(SELECT tick_number,${operation}(wholeUpdate) as wholeUpdate from benchmark_verbose where benchmark_id = $benchmark_id group by tick_number) as id${benchmark_id},\n"
done | sed '$s/,$//' >> pivot.sql

printf "WHERE " >> pivot.sql

first_id=$(echo $ids_to_collect | head -n1 | awk '{print $1}')
for benchmark_id in $ids_to_collect ; do
	if [[ $first_id != $benchmark_id ]] ; then
		printf "id${first_id}.tick_number = id${benchmark_id}.tick_number AND "
	fi
done | sed 's/ AND $//' >> pivot.sql

printf ";\n" >> pivot.sql

echo "Finished generating SQL, running query."

cat pivot.sql | sqlite3 test.db -cmd ".mode csv" -cmd ".headers on"
