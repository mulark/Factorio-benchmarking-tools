CREATE TABLE `benchmark_collection` (
  `collection_id` integer NOT NULL PRIMARY KEY AUTOINCREMENT
,  `pattern` varchar(100) DEFAULT NULL
,  `factorio_version` varchar(10) DEFAULT NULL
,  `ticks` integer DEFAULT NULL
,  `platform` varchar(100) DEFAULT NULL
,  `executable_type` varchar(100) DEFAULT NULL
,  `number_of_mods_installed` integer DEFAULT NULL
,  `notes` text DEFAULT NULL
,  `kernel_version` text DEFAULT NULL
);

CREATE TABLE `benchmark_base` (
  `benchmark_id` integer NOT NULL PRIMARY KEY AUTOINCREMENT
,  `map_name` varchar(100) DEFAULT NULL
,  `saved_map_version` varchar(10) DEFAULT NULL
,  `number_of_runs` integer DEFAULT NULL CHECK (`number_of_runs` > 0)
,  `avg_ms` double(3,3) DEFAULT NULL
,  `ticks` integer DEFAULT NULL
,  `collection_id` integer DEFAULT NULL
,  `map_hash` varchar(40) DEFAULT NULL
,  CONSTRAINT `benchmark_base_ibfk_1` FOREIGN KEY (`collection_id`) REFERENCES `benchmark_collection` (`collection_id`)
,  CONSTRAINT `hash_length_check` CHECK (length(`map_hash`) = 40)
);
CREATE INDEX "idx_benchmark_base_collection_id" ON "benchmark_base" (`collection_id`);

CREATE TABLE IF NOT EXISTS "benchmark_verbose" (
'unused_row_index' integer PRIMARY KEY AUTOINCREMENT
,  `run_index` integer NOT NULL
,  `tick_number` integer NOT NULL
,  `wholeUpdate` integer  DEFAULT NULL
,  `gameUpdate` integer  DEFAULT NULL
,  `circuitNetworkUpdate` integer  DEFAULT NULL
,  `transportLinesUpdate` integer  DEFAULT NULL
,  `fluidsUpdate` integer  DEFAULT NULL
,  `entityUpdate` integer  DEFAULT NULL
,  `mapGenerator` integer  DEFAULT NULL
,  `electricNetworkUpdate` integer  DEFAULT NULL
,  `logisticManagerUpdate` integer  DEFAULT NULL
,  `constructionManagerUpdate` integer  DEFAULT NULL
,  `pathFinder` integer  DEFAULT NULL
,  `trains` integer  DEFAULT NULL
,  `trainPathFinder` integer  DEFAULT NULL
,  `commander` integer  DEFAULT NULL
,  `chartRefresh` integer  DEFAULT NULL
,  `luaGarbageIncremental` integer  DEFAULT NULL
,  `chartUpdate` integer  DEFAULT NULL
,  `scriptUpdate` integer  DEFAULT NULL
,  `benchmark_id` integer DEFAULT NULL
,  CONSTRAINT `benchmark_verbose_ibfk_1` FOREIGN KEY (`benchmark_id`) REFERENCES `benchmark_base` (`benchmark_id`)
);
