|NAME|TYPE|DESCR|
|--|--|--|
|scylla_alien_receive_batch_queue_length|gauge|Current receive batch queue length|
|scylla_alien_total_received_messages|counter|Total number of received messages|
|scylla_alien_total_sent_messages|counter|Total number of sent messages|
|scylla_batchlog_manager_total_write_replay_attempts|counter|Counts write operations issued in a batchlog replay flow. The high value of this metric indicates that we have a long batch replay list.|
|scylla_cache_active_reads|gauge|number of currently active reads|
|scylla_cache_bytes_total|gauge|total size of memory for the cache|
|scylla_cache_bytes_used|gauge|current bytes used by the cache out of the total size of memory|
|scylla_cache_concurrent_misses_same_key|counter|total number of operation with misses same key|
|scylla_cache_mispopulations|counter|number of entries not inserted by reads|
|scylla_cache_partition_evictions|counter|total number of evicted partitions|
|scylla_cache_partition_hits|counter|number of partitions needed by reads and found in cache|
|scylla_cache_partition_insertions|counter|total number of partitions added to cache|
|scylla_cache_partition_merges|counter|total number of partitions merged|
|scylla_cache_partition_misses|counter|number of partitions needed by reads and missing in cache|
|scylla_cache_partition_removals|counter|total number of invalidated partitions|
|scylla_cache_partitions|gauge|total number of cached partitions|
|scylla_cache_pinned_dirty_memory_overload|counter|amount of pinned bytes that we tried to unpin over the limit. This should sit constantly at 0, and any number different than 0 is indicative of a bug|
|scylla_cache_reads|counter|number of started reads|
|scylla_cache_reads_with_misses|counter|number of reads which had to read from sstables|
|scylla_cache_row_evictions|counter|total number of rows evicted from cache|
|scylla_cache_row_hits|counter|total number of rows needed by reads and found in cache|
|scylla_cache_row_insertions|counter|total number of rows added to cache|
|scylla_cache_row_misses|counter|total number of rows needed by reads and missing in cache|
|scylla_cache_row_removals|counter|total number of invalidated rows|
|scylla_cache_rows|gauge|total number of cached rows|
|scylla_cache_rows_dropped_from_memtable|counter|total number of rows in memtables which were dropped during cache update on memtable flush|
|scylla_cache_rows_merged_from_memtable|counter|total number of rows in memtables which were merged with existing rows during cache update on memtable flush|
|scylla_cache_rows_processed_from_memtable|counter|total number of rows in memtables which were processed during cache update on memtable flush|
|scylla_cache_sstable_partition_skips|counter|number of times sstable reader was fast forwarded across partitions|
|scylla_cache_sstable_reader_recreations|counter|number of times sstable reader was recreated due to memtable flush|
|scylla_cache_sstable_row_skips|counter|number of times sstable reader was fast forwarded within a partition|
|scylla_cache_static_row_insertions|counter|total number of static rows added to cache|
|scylla_cdc_operations_failed|counter|number of failed CDC operations|
|scylla_cdc_operations_on_clustering_row_performed_failed|counter|number of failed CDC operations that processed a clustering_row|
|scylla_cdc_operations_on_clustering_row_performed_total|counter|number of total CDC operations that processed a clustering_row|
|scylla_cdc_operations_on_list_performed_failed|counter|number of failed CDC operations that processed a list|
|scylla_cdc_operations_on_list_performed_total|counter|number of total CDC operations that processed a list|
|scylla_cdc_operations_on_map_performed_failed|counter|number of failed CDC operations that processed a map|
|scylla_cdc_operations_on_map_performed_total|counter|number of total CDC operations that processed a map|
|scylla_cdc_operations_on_partition_delete_performed_failed|counter|number of failed CDC operations that processed a partition_delete|
|scylla_cdc_operations_on_partition_delete_performed_total|counter|number of total CDC operations that processed a partition_delete|
|scylla_cdc_operations_on_range_tombstone_performed_failed|counter|number of failed CDC operations that processed a range_tombstone|
|scylla_cdc_operations_on_range_tombstone_performed_total|counter|number of total CDC operations that processed a range_tombstone|
|scylla_cdc_operations_on_row_delete_performed_failed|counter|number of failed CDC operations that processed a row_delete|
|scylla_cdc_operations_on_row_delete_performed_total|counter|number of total CDC operations that processed a row_delete|
|scylla_cdc_operations_on_set_performed_failed|counter|number of failed CDC operations that processed a set|
|scylla_cdc_operations_on_set_performed_total|counter|number of total CDC operations that processed a set|
|scylla_cdc_operations_on_static_row_performed_failed|counter|number of failed CDC operations that processed a static_row|
|scylla_cdc_operations_on_static_row_performed_total|counter|number of total CDC operations that processed a static_row|
|scylla_cdc_operations_on_udt_performed_failed|counter|number of failed CDC operations that processed a udt|
|scylla_cdc_operations_on_udt_performed_total|counter|number of total CDC operations that processed a udt|
|scylla_cdc_operations_total|counter|number of total CDC operations|
|scylla_cdc_operations_with_postimage_failed|counter|number of failed operations that included postimage|
|scylla_cdc_operations_with_postimage_total|counter|number of total operations that included postimage|
|scylla_cdc_operations_with_preimage_failed|counter|number of failed operations that included preimage|
|scylla_cdc_operations_with_preimage_total|counter|number of total operations that included preimage|
|scylla_cdc_preimage_selects_failed|counter|number of failed preimage queries performed|
|scylla_cdc_preimage_selects_total|counter|number of total preimage queries performed|
|scylla_commitlog_alloc|counter|Counts a number of times a new mutation has been added to a segment. Divide bytes_written by this value to get the average number of bytes per mutation written to the disk.|
|scylla_commitlog_allocating_segments|gauge|Holds the number of not closed segments that still have some free space. This value should not get too high.|
|scylla_commitlog_bytes_written|counter|Counts a number of bytes written to the disk. Divide this value by "alloc" to get the average number of bytes per mutation written to the disk.|
|scylla_commitlog_cycle|counter|Counts a number of commitlog write cycles - when the data is written from the internal memory buffer to the disk.|
|scylla_commitlog_disk_active_bytes|gauge|Holds a size of disk space in bytes used for data so far. A too high value indicates that we have some bottleneck in the writing to sstables path.|
|scylla_commitlog_disk_total_bytes|gauge|Holds a size of disk space in bytes reserved for data so far. A too high value indicates that we have some bottleneck in the writing to sstables path.|
|scylla_commitlog_flush|counter|Counts a number of times the flush() method was called for a file.|
|scylla_commitlog_flush_limit_exceeded|counter|Counts a number of times a flush limit was exceeded. A non-zero value indicates that there are too many pending flush operations (see pending_flushes) and some of them will be blocked till the total amount of pending flush operations drops below 5.|
|scylla_commitlog_memory_buffer_bytes|gauge|Holds the total number of bytes in internal memory buffers.|
|scylla_commitlog_pending_allocations|gauge|Holds a number of currently pending allocations. A non-zero value indicates that we have a bottleneck in the disk write flow.|
|scylla_commitlog_pending_flushes|gauge|Holds a number of currently pending flushes. See the related flush_limit_exceeded metric.|
|scylla_commitlog_requests_blocked_memory|counter|Counts a number of requests blocked due to memory pressure. A non-zero value indicates that the commitlog memory quota is not enough to serve the required amount of requests.|
|scylla_commitlog_segments|gauge|Holds the current number of segments.|
|scylla_commitlog_slack|counter|Counts a number of unused bytes written to the disk due to disk segment alignment.|
|scylla_commitlog_unused_segments|gauge|Holds the current number of unused segments. A non-zero value indicates that the disk write path became temporary slow.|
|scylla_compaction_manager_backlog|gauge|Holds the sum of compaction backlog for all tables in the system.|
|scylla_compaction_manager_compactions|gauge|Holds the number of currently active compactions.|
|scylla_compaction_manager_pending_compactions|gauge|Holds the number of compaction tasks waiting for an opportunity to run.|
|scylla_cql_authorized_prepared_statements_cache_evictions|counter|Counts the number of authenticated prepared statements cache entries evictions.|
|scylla_cql_authorized_prepared_statements_cache_size|gauge|Number of entries in the authenticated prepared statements cache.|
|scylla_cql_batches|counter|Counts the total number of CQL BATCH requests without conditions.|
|scylla_cql_batches_pure_logged|counter|Counts the total number of LOGGED batches that were executed as LOGGED batches.|
|scylla_cql_batches_pure_unlogged|counter|Counts the total number of UNLOGGED batches that were executed as UNLOGGED batches.|
|scylla_cql_batches_unlogged_from_logged|counter|Counts the total number of LOGGED batches that were executed as UNLOGGED batches.|
|scylla_cql_deletes|counter|Counts the total number of CQL DELETE requests with/without conditions.|
|scylla_cql_deletes_per_ks|counter|Counts the number of CQL DELETE requests executed on particular keyspaces. Label `who' indicates where the reqs come from (clients or DB internals)|
|scylla_cql_filtered_read_requests|counter|Counts the total number of CQL read requests that required ALLOW FILTERING. See filtered_rows_read_total to compare how many rows needed to be filtered.|
|scylla_cql_filtered_rows_dropped_total|counter|Counts the number of rows read during CQL requests that required ALLOW FILTERING and dropped by the filter. Number similar to filtered_rows_read_total indicates that filtering is not accurate and might cause performance degradation.|
|scylla_cql_filtered_rows_matched_total|counter|Counts the number of rows read during CQL requests that required ALLOW FILTERING and accepted by the filter. Number similar to filtered_rows_read_total indicates that filtering is accurate.|
|scylla_cql_filtered_rows_read_total|counter|Counts the total number of rows read during CQL requests that required ALLOW FILTERING. See filtered_rows_matched_total and filtered_rows_dropped_total for information how accurate filtering queries are.|
|scylla_cql_inserts|counter|Counts the total number of CQL INSERT requests with/without conditions.|
|scylla_cql_inserts_per_ks|counter|Counts the number of CQL INSERT requests executed on particular keyspaces. Label `who' indicates where the reqs come from (clients or DB internals).|
|scylla_cql_prepared_cache_evictions|counter|Counts the number of prepared statements cache entries evictions.|
|scylla_cql_prepared_cache_memory_footprint|gauge|Size (in bytes) of the prepared statements cache.|
|scylla_cql_prepared_cache_size|gauge|A number of entries in the prepared statements cache.|
|scylla_cql_reads|counter|Counts the total number of CQL SELECT requests.|
|scylla_cql_reads_per_ks|counter|Counts the number of CQL SELECT requests executed on particular keyspaces. Label `who' indicates where the reqs come from (clients or DB internals)|
|scylla_cql_reverse_queries|counter|Counts the number of CQL SELECT requests with reverse ORDER BY order.|
|scylla_cql_rows_read|counter|Counts the total number of rows read during CQL requests.|
|scylla_cql_secondary_index_creates|counter|Counts the total number of CQL CREATE INDEX requests.|
|scylla_cql_secondary_index_drops|counter|Counts the total number of CQL DROP INDEX requests.|
|scylla_cql_secondary_index_reads|counter|Counts the total number of CQL read requests performed using secondary indexes.|
|scylla_cql_secondary_index_rows_read|counter|Counts the total number of rows read during CQL requests performed using secondary indexes.|
|scylla_cql_select_allow_filtering|counter|Counts the number of SELECT query executions with ALLOW FILTERING option.|
|scylla_cql_select_bypass_caches|counter|Counts the number of SELECT query executions with BYPASS CACHE option.|
|scylla_cql_select_partition_range_scan|counter|Counts the number of SELECT query executions requiring partition range scan.|
|scylla_cql_select_partition_range_scan_no_bypass_cache|counter|Counts the number of SELECT query executions requiring partition range scan without BYPASS CACHE option.|
|scylla_cql_statements_in_batches|counter|Counts the total number of sub-statements in CQL BATCH requests without conditions.|
|scylla_cql_unpaged_select_queries|counter|Counts the total number of unpaged CQL SELECT requests.|
|scylla_cql_unpaged_select_queries_per_ks|counter|Counts the number of unpaged CQL SELECT requests against particular keyspaces.|
|scylla_cql_updates|counter|Counts the total number of CQL UPDATE requests with/without conditions.|
|scylla_cql_updates_per_ks|counter|Counts the number of CQL UPDATE requests executed on particular keyspaces. Label `who' indicates where the reqs come from (clients or DB internals)|
|scylla_cql_user_prepared_auth_cache_footprint|gauge|Size (in bytes) of the authenticated prepared statements cache.|
|scylla_database_active_reads|gauge|Holds the number of currently active read operations.|
|scylla_database_active_reads_memory_consumption|gauge|Holds the amount of memory consumed by currently active read operations. If this value gets close to 269442088 we are likely to start dropping new read requests. In that case sstable_read_queue_overloads is going to get a non-zero value.|
|scylla_database_clustering_filter_count|counter|Counts bloom filter invocations.|
|scylla_database_clustering_filter_fast_path_count|counter|Counts number of times bloom filtering short cut to include all sstables when only one full range was specified.|
|scylla_database_clustering_filter_sstables_checked|counter|Counts sstables checked after applying the bloom filter. High value indicates that bloom filter is not very efficient.|
|scylla_database_clustering_filter_surviving_sstables|counter|Counts sstables that survived the clustering key filtering. High value indicates that bloom filter is not very efficient and still have to access a lot of sstables to get data.|
|scylla_database_counter_cell_lock_acquisition|counter|The number of acquired counter cell locks.|
|scylla_database_counter_cell_lock_pending|gauge|The number of counter updates waiting for a lock.|
|scylla_database_dropped_view_updates|counter|Counts the number of view updates that have been dropped due to cluster overload.|
|scylla_database_large_partition_exceeding_threshold|counter|Number of large partitions exceeding compaction_large_partition_warning_threshold_mb. Large partitions have performance impact and should be avoided, check the documentation for details.|
|scylla_database_multishard_query_failed_reader_saves|counter|The number of times the saving of a shard reader failed.|
|scylla_database_multishard_query_failed_reader_stops|counter|The number of times the stopping of a shard reader failed.|
|scylla_database_multishard_query_unpopped_bytes|counter|The total number of bytes that were extracted from the shard reader but were unconsumed by the query and moved back into the reader.|
|scylla_database_multishard_query_unpopped_fragments|counter|The total number of fragments that were extracted from the shard reader but were unconsumed by the query and moved back into the reader.|
|scylla_database_paused_reads|gauge|The number of currently active reads that are temporarily paused.|
|scylla_database_paused_reads_permit_based_evictions|counter|The number of paused reads evicted to free up permits. Permits are required for new reads to start, and the database will evict paused reads (if any) to be able to admit new ones, if there is a shortage of permits.|
|scylla_database_querier_cache_drops|counter|Counts querier cache lookups that found a cached querier but had to drop it due to position mismatch|
|scylla_database_querier_cache_lookups|counter|Counts querier cache lookups (paging queries)|
|scylla_database_querier_cache_memory_based_evictions|counter|Counts querier cache entries that were evicted because the memory usage of the cached queriers were above the limit.|
|scylla_database_querier_cache_misses|counter|Counts querier cache lookups that failed to find a cached querier|
|scylla_database_querier_cache_population|gauge|The number of entries currently in the querier cache.|
|scylla_database_querier_cache_resource_based_evictions|counter|Counts querier cache entries that were evicted to free up resources (limited by reader concurency limits) necessary to create new readers.|
|scylla_database_querier_cache_time_based_evictions|counter|Counts querier cache entries that timed out and were evicted.|
|scylla_database_queued_reads|gauge|Holds the number of currently queued read operations.|
|scylla_database_requests_blocked_memory|counter|Holds the current number of requests blocked due to reaching the memory quota (3031223500B). Non-zero value indicates that our bottleneck is memory and more specifically - the memory quota allocated for the "database" component.|
|scylla_database_requests_blocked_memory_current|gauge|Holds the current number of requests blocked due to reaching the memory quota (3031223500B). Non-zero value indicates that our bottleneck is memory and more specifically - the memory quota allocated for the "database" component.|
|scylla_database_schema_changed|counter|The number of times the schema changed|
|scylla_database_short_data_queries|counter|The rate of data queries (data or digest reads) that returned less rows than requested due to result size limiting.|
|scylla_database_short_mutation_queries|counter|The rate of mutation queries that returned less rows than requested due to result size limiting.|
|scylla_database_sstable_read_queue_overloads|counter|Counts the number of times the sstable read queue was overloaded. A non-zero value indicates that we have to drop read requests because they arrive faster than we can serve them.|
|scylla_database_total_reads|counter|Counts the total number of successful user reads on this shard.|
|scylla_database_total_reads_failed|counter|Counts the total number of failed user read operations. Add the total_reads to this value to get the total amount of reads issued on this shard.|
|scylla_database_total_result_bytes|gauge|Holds the current amount of memory used for results.|
|scylla_database_total_view_updates_failed_local|counter|Total number of view updates generated for tables and failed to be applied locally.|
|scylla_database_total_view_updates_failed_remote|counter|Total number of view updates generated for tables and failed to be sent to remote replicas.|
|scylla_database_total_view_updates_pushed_local|counter|Total number of view updates generated for tables and applied locally.|
|scylla_database_total_view_updates_pushed_remote|counter|Total number of view updates generated for tables and sent to remote replicas.|
|scylla_database_total_writes|counter|Counts the total number of successful write operations performed by this shard.|
|scylla_database_total_writes_failed|counter|Counts the total number of failed write operations. A sum of this value plus total_writes represents a total amount of writes attempted on this shard.|
|scylla_database_total_writes_timedout|counter|Counts write operations failed due to a timeout. A positive value is a sign of storage being overloaded.|
|scylla_database_view_building_paused|counter|Counts the number of times view building process was paused (e.g. due to node unavailability).|
|scylla_database_view_update_backlog|counter|Holds the current size in bytes of the pending view updates for all tables|
|scylla_execution_stages_function_calls_enqueued|counter|Counts function calls added to execution stages queues|
|scylla_execution_stages_function_calls_executed|counter|Counts function calls executed by execution stages|
|scylla_execution_stages_tasks_preempted|counter|Counts tasks which were preempted before execution all queued operations|
|scylla_execution_stages_tasks_scheduled|counter|Counts tasks scheduled by execution stages|
|scylla_gossip_heart_beat|counter|Heartbeat of the current Node.|
|scylla_hints_for_views_manager_corrupted_files|counter|Number of hints files that were discarded during sending because the file was corrupted.|
|scylla_hints_for_views_manager_discarded|counter|Number of hints that were discarded during sending (too old, schema changed, etc.).|
|scylla_hints_for_views_manager_dropped|counter|Number of dropped hints.|
|scylla_hints_for_views_manager_errors|counter|Number of errors during hints writes.|
|scylla_hints_for_views_manager_pending_drains|gauge|Number of tasks waiting in the queue for draining hints|
|scylla_hints_for_views_manager_pending_sends|gauge|Number of tasks waiting in the queue for sending a hint|
|scylla_hints_for_views_manager_sent|counter|Number of sent hints.|
|scylla_hints_for_views_manager_size_of_hints_in_progress|gauge|Size of hinted mutations that are scheduled to be written.|
|scylla_hints_for_views_manager_written|counter|Number of successfully written hints.|
|scylla_hints_manager_corrupted_files|counter|Number of hints files that were discarded during sending because the file was corrupted.|
|scylla_hints_manager_discarded|counter|Number of hints that were discarded during sending (too old, schema changed, etc.).|
|scylla_hints_manager_dropped|counter|Number of dropped hints.|
|scylla_hints_manager_errors|counter|Number of errors during hints writes.|
|scylla_hints_manager_pending_drains|gauge|Number of tasks waiting in the queue for draining hints|
|scylla_hints_manager_pending_sends|gauge|Number of tasks waiting in the queue for sending a hint|
|scylla_hints_manager_sent|counter|Number of sent hints.|
|scylla_hints_manager_size_of_hints_in_progress|gauge|Size of hinted mutations that are scheduled to be written.|
|scylla_hints_manager_written|counter|Number of successfully written hints.|
|scylla_httpd_connections_current|gauge|The current number of open  connections|
|scylla_httpd_connections_total|counter|The total number of connections opened|
|scylla_httpd_read_errors|counter|The total number of errors while reading http requests|
|scylla_httpd_reply_errors|counter|The total number of errors while replying to http|
|scylla_httpd_requests_served|counter|The total number of http requests served|
|scylla_io_queue_delay|gauge|total delay time in the queue|
|scylla_io_queue_queue_length|gauge|Number of requests in the queue|
|scylla_io_queue_shares|gauge|current amount of shares|
|scylla_io_queue_total_bytes|counter|Total bytes passed in the queue|
|scylla_io_queue_total_operations|counter|Total bytes passed in the queue|
|scylla_lsa_free_space|gauge|Holds a current amount of free memory that is under lsa control.|
|scylla_lsa_large_objects_total_space_bytes|gauge|Holds a current size of allocated non-LSA memory.|
|scylla_lsa_memory_allocated|counter|Counts number of bytes which were requested from LSA allocator.|
|scylla_lsa_memory_compacted|counter|Counts number of bytes which were copied as part of segment compaction.|
|scylla_lsa_non_lsa_used_space_bytes|gauge|Holds a current amount of used non-LSA memory.|
|scylla_lsa_occupancy|gauge|Holds a current portion (in percents) of the used memory.|
|scylla_lsa_segments_compacted|counter|Counts a number of compacted segments.|
|scylla_lsa_small_objects_total_space_bytes|gauge|Holds a current size of "small objects" memory region in bytes.|
|scylla_lsa_small_objects_used_space_bytes|gauge|Holds a current amount of used "small objects" memory in bytes.|
|scylla_lsa_total_space_bytes|gauge|Holds a current size of allocated memory in bytes.|
|scylla_lsa_used_space_bytes|gauge|Holds a current amount of used memory in bytes.|
|scylla_memory_allocated_memory|counter|Allocated memeory size in bytes|
|scylla_memory_cross_cpu_free_operations|counter|Total number of cross cpu free|
|scylla_memory_dirty_bytes|gauge|Holds the current size of all ("regular", "system" and "streaming") non-free memory in bytes: used memory + released memory that hasn't been returned to a free memory pool yet. Total memory size minus this value represents the amount of available memory. If this value minus virtual_dirty_bytes is too high then this means that the dirty memory eviction lags behind.|
|scylla_memory_free_memory|counter|Free memeory size in bytes|
|scylla_memory_free_operations|counter|Total number of free operations|
|scylla_memory_malloc_live_objects|gauge|Number of live objects|
|scylla_memory_malloc_operations|counter|Total number of malloc operations|
|scylla_memory_reclaims_operations|counter|Total reclaims operations|
|scylla_memory_regular_dirty_bytes|gauge|Holds the current size of a all non-free memory in bytes: used memory + released memory that hasn't been returned to a free memory pool yet. Total memory size minus this value represents the amount of available memory. If this value minus virtual_dirty_bytes is too high then this means that the dirty memory eviction lags behind.|
|scylla_memory_regular_virtual_dirty_bytes|gauge|Holds the size of used memory in bytes. Compare it to "dirty_bytes" to see how many memory is wasted (neither used nor available).|
|scylla_memory_streaming_dirty_bytes|gauge|Holds the current size of a all non-free memory in bytes: used memory + released memory that hasn't been returned to a free memory pool yet. Total memory size minus this value represents the amount of available memory. If this value minus virtual_dirty_bytes is too high then this means that the dirty memory eviction lags behind.|
|scylla_memory_streaming_virtual_dirty_bytes|gauge|Holds the size of used memory in bytes. Compare it to "dirty_bytes" to see how many memory is wasted (neither used nor available).|
|scylla_memory_system_dirty_bytes|gauge|Holds the current size of a all non-free memory in bytes: used memory + released memory that hasn't been returned to a free memory pool yet. Total memory size minus this value represents the amount of available memory. If this value minus virtual_dirty_bytes is too high then this means that the dirty memory eviction lags behind.|
|scylla_memory_system_virtual_dirty_bytes|gauge|Holds the size of used memory in bytes. Compare it to "dirty_bytes" to see how many memory is wasted (neither used nor available).|
|scylla_memory_total_memory|counter|Total memeory size in bytes|
|scylla_memory_virtual_dirty_bytes|gauge|Holds the size of all ("regular", "system" and "streaming") used memory in bytes. Compare it to "dirty_bytes" to see how many memory is wasted (neither used nor available).|
|scylla_memtables_failed_flushes|gauge|Holds the number of failed memtable flushes. High value in this metric may indicate a permanent failure to flush a memtable.|
|scylla_memtables_pending_flushes|gauge|Holds the current number of memtables that are currently being flushed to sstables. High value in this metric may be an indication of storage being a bottleneck.|
|scylla_memtables_pending_flushes_bytes|gauge|Holds the current number of bytes in memtables that are currently being flushed to sstables. High value in this metric may be an indication of storage being a bottleneck.|
|scylla_node_maintenance_operations_bootstrap_finished_percentage|gauge|Number of finished percentage for bootstrap operation on this shard.|
|scylla_node_maintenance_operations_decommission_finished_percentage|gauge|Number of finished percentage for decommission operation on this shard.|
|scylla_node_maintenance_operations_rebuild_finished_percentage|gauge|Number of finished percentage for rebuild operation on this shard.|
|scylla_node_maintenance_operations_removenode_finished_percentage|gauge|Number of finished percentage for removenode operation on this shard.|
|scylla_node_maintenance_operations_repair_finished_percentage|gauge|Number of finished percentage for repair operation on this shard.|
|scylla_node_maintenance_operations_replace_finished_percentage|gauge|Number of finished percentage for replace operation on this shard.|
|scylla_node_operation_mode|gauge|The operation mode of the current node. UNKNOWN = 0, STARTING = 1, JOINING = 2, NORMAL = 3, LEAVING = 4, DECOMMISSIONED = 5, DRAINING = 6, DRAINED = 7, MOVING = 8|
|scylla_query_processor_queries|counter|Counts queries by consistency level.|
|scylla_query_processor_statements_prepared|counter|Counts the total number of parsed CQL requests.|
|scylla_reactor_abandoned_failed_futures|counter|Total number of abandoned failed futures, futures destroyed while still containing an exception|
|scylla_reactor_aio_bytes_read|counter|Total aio-reads bytes|
|scylla_reactor_aio_bytes_write|counter|Total aio-writes bytes|
|scylla_reactor_aio_errors|counter|Total aio errors|
|scylla_reactor_aio_reads|counter|Total aio-reads operations|
|scylla_reactor_aio_writes|counter|Total aio-writes operations|
|scylla_reactor_cpp_exceptions|counter|Total number of C++ exceptions|
|scylla_reactor_cpu_busy_ms|counter|Total cpu busy time in milliseconds|
|scylla_reactor_cpu_steal_time_ms|counter|Total steal time, the time in which some other process was running while Seastar was not trying to run (not sleeping).Because this is in userspace, some time that could be legitimally thought as steal time is not accounted as such. For example, if we are sleeping and can wake up but the kernel hasn't woken us up yet.|
|scylla_reactor_fstream_read_bytes|counter|Counts bytes read from disk file streams.  A high rate indicates high disk activity. Divide by fstream_reads to determine average read size.|
|scylla_reactor_fstream_read_bytes_blocked|counter|Counts the number of bytes read from disk that could not be satisfied from read-ahead buffers, and had to block. Indicates short streams, or incorrect read ahead configuration.|
|scylla_reactor_fstream_reads|counter|Counts reads from disk file streams.  A high rate indicates high disk activity. Contrast with other fstream_read* counters to locate bottlenecks.|
|scylla_reactor_fstream_reads_ahead_bytes_discarded|counter|Counts the number of buffered bytes that were read ahead of time and were discarded because they were not needed, wasting disk bandwidth. Indicates over-eager read ahead configuration.|
|scylla_reactor_fstream_reads_aheads_discarded|counter|Counts the number of times a buffer that was read ahead of time and was discarded because it was not needed, wasting disk bandwidth. Indicates over-eager read ahead configuration.|
|scylla_reactor_fstream_reads_blocked|counter|Counts the number of times a disk read could not be satisfied from read-ahead buffers, and had to block. Indicates short streams, or incorrect read ahead configuration.|
|scylla_reactor_fsyncs|counter|Total number of fsync operations|
|scylla_reactor_io_threaded_fallbacks|counter|Total number of io-threaded-fallbacks operations|
|scylla_reactor_logging_failures|counter|Total number of logging failures|
|scylla_reactor_polls|counter|Number of times pollers were executed|
|scylla_reactor_tasks_pending|gauge|Number of pending tasks in the queue|
|scylla_reactor_tasks_processed|counter|Total tasks processed|
|scylla_reactor_timers_pending|counter|Number of tasks in the timer-pending queue|
|scylla_reactor_utilization|gauge|CPU utilization|
|scylla_repair_row_from_disk_bytes|counter|Total bytes of rows read from disk on this shard.|
|scylla_repair_row_from_disk_nr|counter|Total number of rows read from disk on this shard.|
|scylla_repair_rx_hashes_nr|counter|Total number of row hashes received on this shard.|
|scylla_repair_rx_row_bytes|counter|Total bytes of rows received on this shard.|
|scylla_repair_rx_row_nr|counter|Total number of rows received on this shard.|
|scylla_repair_tx_hashes_nr|counter|Total number of row hashes sent on this shard.|
|scylla_repair_tx_row_bytes|counter|Total bytes of rows sent on this shard.|
|scylla_repair_tx_row_nr|counter|Total number of rows sent on this shard.|
|scylla_scheduler_queue_length|gauge|Size of backlog on this queue, in tasks; indicates whether the queue is busy and/or contended|
|scylla_scheduler_runtime_ms|counter|Accumulated runtime of this task queue; an increment rate of 1000ms per second indicates full utilization|
|scylla_scheduler_shares|gauge|Shares allocated to this queue|
|scylla_scheduler_tasks_processed|counter|Count of tasks executing on this queue; indicates together with runtime_ms indicates length of tasks|
|scylla_scheduler_time_spent_on_task_quota_violations_ms|counter|Total amount in milliseconds we were in violation of the task quota|
|scylla_scylladb_current_version|gauge|Current ScyllaDB version.|
|scylla_sstables_capped_local_deletion_time|counter|Was local deletion time capped at maximum allowed value in Statistics|
|scylla_sstables_capped_tombstone_deletion_time|counter|Was partition tombstone deletion time capped at maximum allowed value|
|scylla_sstables_cell_tombstone_writes|counter|Number of cell tombstones written|
|scylla_sstables_cell_writes|counter|Number of cells written|
|scylla_sstables_index_page_blocks|counter|Index page requests which needed to wait due to page not being loaded yet|
|scylla_sstables_index_page_cache_bytes|gauge|Total number of bytes cached in the index page cache|
|scylla_sstables_index_page_cache_evictions|counter|Total number of index page cache pages which have been evicted|
|scylla_sstables_index_page_cache_hits|counter|Index page cache requests which were served from cache|
|scylla_sstables_index_page_cache_misses|counter|Index page cache requests which had to perform I/O|
|scylla_sstables_index_page_cache_populations|counter|Total number of index page cache pages which were inserted into the cache|
|scylla_sstables_index_page_hits|counter|Index page requests which could be satisfied without waiting|
|scylla_sstables_index_page_misses|counter|Index page requests which initiated a read from disk|
|scylla_sstables_partition_reads|counter|Number of partitions read|
|scylla_sstables_partition_seeks|counter|Number of partitions seeked|
|scylla_sstables_partition_writes|counter|Number of partitions written|
|scylla_sstables_pi_cache_block_count|gauge|Number of promoted index blocks currently cached|
|scylla_sstables_pi_cache_bytes|gauge|Number of bytes currently used by cached promoted index blocks|
|scylla_sstables_pi_cache_evictions|counter|Number of promoted index blocks which got evicted|
|scylla_sstables_pi_cache_hits_l0|counter|Number of requests for promoted index block in state l0 which didn't have to go to the page cache|
|scylla_sstables_pi_cache_hits_l1|counter|Number of requests for promoted index block in state l1 which didn't have to go to the page cache|
|scylla_sstables_pi_cache_hits_l2|counter|Number of requests for promoted index block in state l2 which didn't have to go to the page cache|
|scylla_sstables_pi_cache_misses_l0|counter|Number of requests for promoted index block in state l0 which had to go to the page cache|
|scylla_sstables_pi_cache_misses_l1|counter|Number of requests for promoted index block in state l1 which had to go to the page cache|
|scylla_sstables_pi_cache_misses_l2|counter|Number of requests for promoted index block in state l2 which had to go to the page cache|
|scylla_sstables_pi_cache_populations|counter|Number of promoted index blocks which got inserted|
|scylla_sstables_range_partition_reads|counter|Number of partition range flat mutation reads|
|scylla_sstables_range_tombstone_writes|counter|Number of range tombstones written|
|scylla_sstables_row_reads|counter|Number of rows read|
|scylla_sstables_row_writes|counter|Number of clustering rows written|
|scylla_sstables_single_partition_reads|counter|Number of single partition flat mutation reads|
|scylla_sstables_sstable_partition_reads|counter|Number of whole sstable flat mutation reads|
|scylla_sstables_static_row_writes|counter|Number of static rows written|
|scylla_sstables_tombstone_writes|counter|Number of tombstones written|
|scylla_stall_detector_reported|counter|Total number of reported stalls, look in the traces for the exact reason|
|scylla_storage_proxy_coordinator_background_read_repairs|counter|number of background read repairs|
|scylla_storage_proxy_coordinator_background_reads|gauge|number of currently pending background read requests|
|scylla_storage_proxy_coordinator_background_replica_writes_failed_local_node|counter|number of replica writes that timed out or failed after CL was reachedon a local Node|
|scylla_storage_proxy_coordinator_background_replica_writes_failed_remote_node|counter|number of replica writes that timed out or failed after CL was reached when communicating with external Nodes in DC datacenter1|
|scylla_storage_proxy_coordinator_background_writes|gauge|number of currently pending background write requests|
|scylla_storage_proxy_coordinator_background_writes_failed|counter|number of write requests that failed after CL was reached|
|scylla_storage_proxy_coordinator_canceled_read_repairs|counter|number of global read repairs canceled due to a concurrent write|
|scylla_storage_proxy_coordinator_cas_background|gauge|how many paxos operations are still running after a result was alredy returned|
|scylla_storage_proxy_coordinator_cas_dropped_prune|counter|how many times a coordinator did not perfom prune after cas|
|scylla_storage_proxy_coordinator_cas_failed_read_round_optimization|counter|CAS read rounds issued only if previous value is missing on some replica|
|scylla_storage_proxy_coordinator_cas_foreground|gauge|how many paxos operations that did not yet produce a result are running|
|scylla_storage_proxy_coordinator_cas_prune|counter|how many times paxos prune was done after successful cas operation|
|scylla_storage_proxy_coordinator_cas_read_contention|histogram|how many contended reads were encountered|
|scylla_storage_proxy_coordinator_cas_read_latency|histogram|Transactional read latency histogram|
|scylla_storage_proxy_coordinator_cas_read_timeouts|counter|number of transactional read request failed due to a timeout|
|scylla_storage_proxy_coordinator_cas_read_unavailable|counter|number of transactional read requests failed due to an "unavailable" error|
|scylla_storage_proxy_coordinator_cas_read_unfinished_commit|counter|number of transaction commit attempts that occurred on read|
|scylla_storage_proxy_coordinator_cas_total_operations|counter|number of total paxos operations executed (reads and writes)|
|scylla_storage_proxy_coordinator_cas_write_condition_not_met|counter|number of transaction preconditions that did not match current values|
|scylla_storage_proxy_coordinator_cas_write_contention|histogram|how many contended writes were encountered|
|scylla_storage_proxy_coordinator_cas_write_latency|histogram|Transactional write latency histogram|
|scylla_storage_proxy_coordinator_cas_write_timeout_due_to_uncertainty|counter|how many times write timeout was reported because of uncertainty in the result|
|scylla_storage_proxy_coordinator_cas_write_timeouts|counter|number of transactional write request failed due to a timeout|
|scylla_storage_proxy_coordinator_cas_write_unavailable|counter|number of transactional write requests failed due to an "unavailable" error|
|scylla_storage_proxy_coordinator_cas_write_unfinished_commit|counter|number of transaction commit attempts that occurred on write|
|scylla_storage_proxy_coordinator_completed_reads_local_node|counter|number of data read requests that completedon a local Node|
|scylla_storage_proxy_coordinator_completed_reads_remote_node|counter|number of digest read requests that completed when communicating with external Nodes in DC datacenter1|
|scylla_storage_proxy_coordinator_current_throttled_base_writes|gauge|number of currently throttled base replica write requests|
|scylla_storage_proxy_coordinator_current_throttled_writes|gauge|number of currently throttled write requests|
|scylla_storage_proxy_coordinator_foreground_read_repairs|counter|number of foreground read repairs|
|scylla_storage_proxy_coordinator_foreground_reads|gauge|number of currently pending foreground read requests|
|scylla_storage_proxy_coordinator_foreground_writes|gauge|number of currently pending foreground write requests|
|scylla_storage_proxy_coordinator_last_mv_flow_control_delay|gauge|delay (in seconds) added for MV flow control in the last request|
|scylla_storage_proxy_coordinator_range_timeouts|counter|number of range read operations failed due to a timeout|
|scylla_storage_proxy_coordinator_range_unavailable|counter|number of range read operations failed due to an "unavailable" error|
|scylla_storage_proxy_coordinator_read_errors_local_node|counter|number of data read requests that failedon a local Node|
|scylla_storage_proxy_coordinator_read_latency|histogram|The general read latency histogram|
|scylla_storage_proxy_coordinator_read_repair_write_attempts_local_node|counter|number of write operations in a read repair contexton a local Node|
|scylla_storage_proxy_coordinator_read_retries|counter|number of read retry attempts|
|scylla_storage_proxy_coordinator_read_timeouts|counter|number of read request failed due to a timeout|
|scylla_storage_proxy_coordinator_read_unavailable|counter|number read requests failed due to an "unavailable" error|
|scylla_storage_proxy_coordinator_reads_coordinator_outside_replica_set|counter|number of CQL read requests which arrived to a non-replica and had to be forwarded to a replica|
|scylla_storage_proxy_coordinator_reads_local_node|counter|number of data read requestson a local Node|
|scylla_storage_proxy_coordinator_reads_remote_node|counter|number of digest read requests when communicating with external Nodes in DC datacenter1|
|scylla_storage_proxy_coordinator_speculative_data_reads|counter|number of speculative data read requests that were sent|
|scylla_storage_proxy_coordinator_speculative_digest_reads|counter|number of speculative digest read requests that were sent|
|scylla_storage_proxy_coordinator_throttled_writes|counter|number of throttled write requests|
|scylla_storage_proxy_coordinator_total_write_attempts_local_node|counter|total number of write requestson a local Node|
|scylla_storage_proxy_coordinator_total_write_attempts_remote_node|counter|total number of write requests when communicating with external Nodes in DC datacenter1|
|scylla_storage_proxy_coordinator_write_errors_local_node|counter|number of write requests that failedon a local Node|
|scylla_storage_proxy_coordinator_write_latency|histogram|The general write latency histogram|
|scylla_storage_proxy_coordinator_write_timeouts|counter|number of write request failed due to a timeout|
|scylla_storage_proxy_coordinator_write_unavailable|counter|number write requests failed due to an "unavailable" error|
|scylla_storage_proxy_coordinator_writes_coordinator_outside_replica_set|counter|number of CQL write requests which arrived to a non-replica and had to be forwarded to a replica|
|scylla_storage_proxy_replica_cas_dropped_prune|counter|how many times a coordinator did not perfom prune after cas|
|scylla_storage_proxy_replica_cross_shard_ops|counter|number of operations that crossed a shard boundary|
|scylla_storage_proxy_replica_forwarded_mutations|counter|number of mutations forwarded to other replica Nodes|
|scylla_storage_proxy_replica_forwarding_errors|counter|number of errors during forwarding mutations to other replica Nodes|
|scylla_storage_proxy_replica_reads|counter|number of remote data read requests this Node received|
|scylla_storage_proxy_replica_received_counter_updates|counter|number of counter updates received by this node acting as an update leader|
|scylla_storage_proxy_replica_received_mutations|counter|number of mutations received by a replica Node|
|scylla_streaming_total_incoming_bytes|counter|Total number of bytes received on this shard.|
|scylla_streaming_total_outgoing_bytes|counter|Total number of bytes sent on this shard.|
|scylla_thrift_current_connections|gauge|Holds a current number of opened Thrift connections.|
|scylla_thrift_served|counter|Rate of serving Thrift requests.|
|scylla_thrift_thrift_connections|counter|Rate of creation of new Thrift connections.|
|scylla_tracing_active_sessions|gauge|Holds a number of a currently active tracing sessions.|
|scylla_tracing_cached_records|gauge|Holds a number of tracing records cached in the tracing sessions that are not going to be written in the next write event. If sum of this metric, pending_for_write_records and flushing_records is close to 11000 we are likely to start dropping tracing records.|
|scylla_tracing_dropped_records|counter|Counts a number of dropped records due to too many pending records. High value indicates that backend is saturated with the rate with which new tracing records are created.|
|scylla_tracing_dropped_sessions|counter|Counts a number of dropped sessions due to too many pending sessions/records. High value indicates that backend is saturated with the rate with which new tracing records are created.|
|scylla_tracing_flushing_records|gauge|Holds a number of tracing records that currently being written to the I/O backend. If sum of this metric, cached_records and pending_for_write_records is close to 11000 we are likely to start dropping tracing records.|
|scylla_tracing_keyspace_helper_bad_column_family_errors|counter|Counts a number of times write failed due to one of the tables in the system_traces keyspace has an incompatible schema. One error may result one or more tracing records to be lost. Non-zero value indicates that the administrator has to take immediate steps to fix the corresponding schema. The appropriate error message will be printed in the syslog.|
|scylla_tracing_keyspace_helper_tracing_errors|counter|Counts a number of errors during writing to a system_traces keyspace. One error may cause one or more tracing records to be lost.|
|scylla_tracing_pending_for_write_records|gauge|Holds a number of tracing records that are going to be written in the next write event. If sum of this metric, cached_records and flushing_records is close to 11000 we are likely to start dropping tracing records.|
|scylla_tracing_trace_errors|counter|Counts a number of trace records dropped due to an error (e.g. OOM).|
|scylla_tracing_trace_records_count|counter|This metric is a rate of tracing records generation.|
|scylla_transport_cql_connections|counter|Counts a number of client connections.|
|scylla_transport_current_connections|gauge|Holds a current number of client connections.|
|scylla_transport_requests_blocked_memory|counter|Holds an incrementing counter with the requests that ever blocked due to reaching the memory quota limit (1347210444B). The first derivative of this value shows how often we block due to memory exhaustion in the "CQL transport" component.|
|scylla_transport_requests_blocked_memory_current|gauge|Holds the number of requests that are currently blocked due to reaching the memory quota limit (1347210444B). Non-zero value indicates that our bottleneck is memory and more specifically - the memory quota allocated for the "CQL transport" component.|
|scylla_transport_requests_memory_available|gauge|Holds the amount of available memory for admitting new requests (max is 1347210444B).Zero value indicates that our bottleneck is memory and more specifically - the memory quota allocated for the "CQL transport" component.|
|scylla_transport_requests_served|counter|Counts a number of served requests.|
|scylla_transport_requests_serving|gauge|Holds a number of requests that are being processed right now.|
|scylla_transport_requests_shed|counter|Holds an incrementing counter with the requests that were shed due to overload (threshold configured via max_concurrent_requests_per_shard). The first derivative of this value shows how often we shed requests due to overload in the "CQL transport" component.|
|scylla_view_builder_builds_in_progress|gauge|Number of currently active view builds.|
|scylla_view_builder_pending_bookkeeping_ops|gauge|Number of tasks waiting to perform bookkeeping operations|
|scylla_view_builder_steps_failed|counter|Number of failed build steps.|
|scylla_view_builder_steps_performed|counter|Number of performed build steps.|
|scylla_view_update_generator_pending_registrations|gauge|Number of tasks waiting to register staging sstables|
|scylla_view_update_generator_queued_batches_count|gauge|Number of sets of sstables queued for view update generation|
|scylla_view_update_generator_sstables_to_move_count|gauge|Number of sets of sstables which are already processed and wait to be moved from their staging directory|
|go_gc_duration_seconds|summary|A summary of the pause duration of garbage collection cycles.|
|go_goroutines|gauge|Number of goroutines that currently exist.|
|go_info|gauge|Information about the Go environment.|
|go_memstats_alloc_bytes|gauge|Number of bytes allocated and still in use.|
|go_memstats_alloc_bytes_total|counter|Total number of bytes allocated, even if freed.|
|go_memstats_buck_hash_sys_bytes|gauge|Number of bytes used by the profiling bucket hash table.|
|go_memstats_frees_total|counter|Total number of frees.|
|go_memstats_gc_cpu_fraction|gauge|The fraction of this program's available CPU time used by the GC since the program started.|
|go_memstats_gc_sys_bytes|gauge|Number of bytes used for garbage collection system metadata.|
|go_memstats_heap_alloc_bytes|gauge|Number of heap bytes allocated and still in use.|
|go_memstats_heap_idle_bytes|gauge|Number of heap bytes waiting to be used.|
|go_memstats_heap_inuse_bytes|gauge|Number of heap bytes that are in use.|
|go_memstats_heap_objects|gauge|Number of allocated objects.|
|go_memstats_heap_released_bytes|gauge|Number of heap bytes released to OS.|
|go_memstats_heap_sys_bytes|gauge|Number of heap bytes obtained from system.|
|go_memstats_last_gc_time_seconds|gauge|Number of seconds since 1970 of last garbage collection.|
|go_memstats_lookups_total|counter|Total number of pointer lookups.|
|go_memstats_mallocs_total|counter|Total number of mallocs.|
|go_memstats_mcache_inuse_bytes|gauge|Number of bytes in use by mcache structures.|
|go_memstats_mcache_sys_bytes|gauge|Number of bytes used for mcache structures obtained from system.|
|go_memstats_mspan_inuse_bytes|gauge|Number of bytes in use by mspan structures.|
|go_memstats_mspan_sys_bytes|gauge|Number of bytes used for mspan structures obtained from system.|
|go_memstats_next_gc_bytes|gauge|Number of heap bytes when next garbage collection will take place.|
|go_memstats_other_sys_bytes|gauge|Number of bytes used for other system allocations.|
|go_memstats_stack_inuse_bytes|gauge|Number of bytes in use by the stack allocator.|
|go_memstats_stack_sys_bytes|gauge|Number of bytes obtained from system for stack allocator.|
|go_memstats_sys_bytes|gauge|Number of bytes obtained from system.|
|go_threads|gauge|Number of OS threads created.|
|node_arp_entries|gauge|ARP entries by device|
|node_bonding_active|gauge|Number of active slaves per bonding interface.|
|node_bonding_slaves|gauge|Number of configured slaves per bonding interface.|
|node_boot_time_seconds|gauge|Node boot time, in unixtime.|
|node_context_switches_total|counter|Total number of context switches.|
|node_cooling_device_cur_state|gauge|Current throttle state of the cooling device|
|node_cooling_device_max_state|gauge|Maximum throttle state of the cooling device|
|node_cpu_core_throttles_total|counter|Number of times this cpu core has been throttled.|
|node_cpu_frequency_max_hertz|gauge|Maximum cpu thread frequency in hertz.|
|node_cpu_frequency_min_hertz|gauge|Minimum cpu thread frequency in hertz.|
|node_cpu_guest_seconds_total|counter|Seconds the cpus spent in guests (VMs) for each mode.|
|node_cpu_package_throttles_total|counter|Number of times this cpu package has been throttled.|
|node_cpu_scaling_frequency_hertz|gauge|Current scaled cpu thread frequency in hertz.|
|node_cpu_scaling_frequency_max_hertz|gauge|Maximum scaled cpu thread frequency in hertz.|
|node_cpu_scaling_frequency_min_hertz|gauge|Minimum scaled cpu thread frequency in hertz.|
|node_cpu_seconds_total|counter|Seconds the cpus spent in each mode.|
|node_disk_io_now|gauge|The number of I/Os currently in progress.|
|node_disk_io_time_seconds_total|counter|Total seconds spent doing I/Os.|
|node_disk_io_time_weighted_seconds_total|counter|The weighted # of seconds spent doing I/Os.|
|node_disk_read_bytes_total|counter|The total number of bytes read successfully.|
|node_disk_read_time_seconds_total|counter|The total number of seconds spent by all reads.|
|node_disk_reads_completed_total|counter|The total number of reads completed successfully.|
|node_disk_reads_merged_total|counter|The total number of reads merged.|
|node_disk_write_time_seconds_total|counter|This is the total number of seconds spent by all writes.|
|node_disk_writes_completed_total|counter|The total number of writes completed successfully.|
|node_disk_writes_merged_total|counter|The number of writes merged.|
|node_disk_written_bytes_total|counter|The total number of bytes written successfully.|
|node_edac_correctable_errors_total|counter|Total correctable memory errors.|
|node_edac_csrow_correctable_errors_total|counter|Total correctable memory errors for this csrow.|
|node_edac_csrow_uncorrectable_errors_total|counter|Total uncorrectable memory errors for this csrow.|
|node_edac_uncorrectable_errors_total|counter|Total uncorrectable memory errors.|
|node_entropy_available_bits|gauge|Bits of available entropy.|
|node_exporter_build_info|gauge|A metric with a constant '1' value labeled by version, revision, branch, and goversion from which node_exporter was built.|
|node_filefd_allocated|gauge|File descriptor statistics: allocated.|
|node_filefd_maximum|gauge|File descriptor statistics: maximum.|
|node_filesystem_avail_bytes|gauge|Filesystem space available to non-root users in bytes.|
|node_filesystem_device_error|gauge|Whether an error occurred while getting statistics for the given device.|
|node_filesystem_files|gauge|Filesystem total file nodes.|
|node_filesystem_files_free|gauge|Filesystem total free file nodes.|
|node_filesystem_free_bytes|gauge|Filesystem free space in bytes.|
|node_filesystem_readonly|gauge|Filesystem read-only status.|
|node_filesystem_size_bytes|gauge|Filesystem size in bytes.|
|node_forks_total|counter|Total number of forks.|
|node_hwmon_chip_names|gauge|Annotation metric for human-readable chip names|
|node_hwmon_sensor_label|gauge|Label for given chip and sensor|
|node_hwmon_temp_celsius|gauge|Hardware monitor for temperature (input)|
|node_hwmon_temp_crit_alarm_celsius|gauge|Hardware monitor for temperature (crit_alarm)|
|node_hwmon_temp_crit_celsius|gauge|Hardware monitor for temperature (crit)|
|node_hwmon_temp_max_celsius|gauge|Hardware monitor for temperature (max)|
|node_interrupts_total|counter|Interrupt details.|
|node_intr_total|counter|Total number of interrupts serviced.|
|node_load1|gauge|1m load average.|
|node_load15|gauge|15m load average.|
|node_load5|gauge|5m load average.|
|node_md_blocks|gauge|Total number of blocks on device.|
|node_md_blocks_synced|gauge|Number of blocks synced on device.|
|node_md_disks|gauge|Number of active/failed/spare disks of device.|
|node_md_disks_required|gauge|Total number of disks of device.|
|node_md_state|gauge|Indicates the state of md-device.|
|node_memory_Active_anon_bytes|gauge|Memory information field Active_anon_bytes.|
|node_memory_Active_bytes|gauge|Memory information field Active_bytes.|
|node_memory_Active_file_bytes|gauge|Memory information field Active_file_bytes.|
|node_memory_AnonHugePages_bytes|gauge|Memory information field AnonHugePages_bytes.|
|node_memory_AnonPages_bytes|gauge|Memory information field AnonPages_bytes.|
|node_memory_Bounce_bytes|gauge|Memory information field Bounce_bytes.|
|node_memory_Buffers_bytes|gauge|Memory information field Buffers_bytes.|
|node_memory_Cached_bytes|gauge|Memory information field Cached_bytes.|
|node_memory_CmaFree_bytes|gauge|Memory information field CmaFree_bytes.|
|node_memory_CmaTotal_bytes|gauge|Memory information field CmaTotal_bytes.|
|node_memory_CommitLimit_bytes|gauge|Memory information field CommitLimit_bytes.|
|node_memory_Committed_AS_bytes|gauge|Memory information field Committed_AS_bytes.|
|node_memory_DirectMap1G_bytes|gauge|Memory information field DirectMap1G_bytes.|
|node_memory_DirectMap2M_bytes|gauge|Memory information field DirectMap2M_bytes.|
|node_memory_DirectMap4k_bytes|gauge|Memory information field DirectMap4k_bytes.|
|node_memory_Dirty_bytes|gauge|Memory information field Dirty_bytes.|
|node_memory_HardwareCorrupted_bytes|gauge|Memory information field HardwareCorrupted_bytes.|
|node_memory_HugePages_Free|gauge|Memory information field HugePages_Free.|
|node_memory_HugePages_Rsvd|gauge|Memory information field HugePages_Rsvd.|
|node_memory_HugePages_Surp|gauge|Memory information field HugePages_Surp.|
|node_memory_HugePages_Total|gauge|Memory information field HugePages_Total.|
|node_memory_Hugepagesize_bytes|gauge|Memory information field Hugepagesize_bytes.|
|node_memory_Inactive_anon_bytes|gauge|Memory information field Inactive_anon_bytes.|
|node_memory_Inactive_bytes|gauge|Memory information field Inactive_bytes.|
|node_memory_Inactive_file_bytes|gauge|Memory information field Inactive_file_bytes.|
|node_memory_KernelStack_bytes|gauge|Memory information field KernelStack_bytes.|
|node_memory_Mapped_bytes|gauge|Memory information field Mapped_bytes.|
|node_memory_MemAvailable_bytes|gauge|Memory information field MemAvailable_bytes.|
|node_memory_MemFree_bytes|gauge|Memory information field MemFree_bytes.|
|node_memory_MemTotal_bytes|gauge|Memory information field MemTotal_bytes.|
|node_memory_Mlocked_bytes|gauge|Memory information field Mlocked_bytes.|
|node_memory_NFS_Unstable_bytes|gauge|Memory information field NFS_Unstable_bytes.|
|node_memory_PageTables_bytes|gauge|Memory information field PageTables_bytes.|
|node_memory_Percpu_bytes|gauge|Memory information field Percpu_bytes.|
|node_memory_SReclaimable_bytes|gauge|Memory information field SReclaimable_bytes.|
|node_memory_SUnreclaim_bytes|gauge|Memory information field SUnreclaim_bytes.|
|node_memory_Shmem_bytes|gauge|Memory information field Shmem_bytes.|
|node_memory_Slab_bytes|gauge|Memory information field Slab_bytes.|
|node_memory_SwapCached_bytes|gauge|Memory information field SwapCached_bytes.|
|node_memory_SwapFree_bytes|gauge|Memory information field SwapFree_bytes.|
|node_memory_SwapTotal_bytes|gauge|Memory information field SwapTotal_bytes.|
|node_memory_Unevictable_bytes|gauge|Memory information field Unevictable_bytes.|
|node_memory_VmallocChunk_bytes|gauge|Memory information field VmallocChunk_bytes.|
|node_memory_VmallocTotal_bytes|gauge|Memory information field VmallocTotal_bytes.|
|node_memory_VmallocUsed_bytes|gauge|Memory information field VmallocUsed_bytes.|
|node_memory_WritebackTmp_bytes|gauge|Memory information field WritebackTmp_bytes.|
|node_memory_Writeback_bytes|gauge|Memory information field Writeback_bytes.|
|node_netstat_Icmp6_InErrors|untyped|Statistic Icmp6InErrors.|
|node_netstat_Icmp6_InMsgs|untyped|Statistic Icmp6InMsgs.|
|node_netstat_Icmp6_OutMsgs|untyped|Statistic Icmp6OutMsgs.|
|node_netstat_Icmp_InErrors|untyped|Statistic IcmpInErrors.|
|node_netstat_Icmp_InMsgs|untyped|Statistic IcmpInMsgs.|
|node_netstat_Icmp_OutMsgs|untyped|Statistic IcmpOutMsgs.|
|node_netstat_Ip6_InOctets|untyped|Statistic Ip6InOctets.|
|node_netstat_Ip6_OutOctets|untyped|Statistic Ip6OutOctets.|
|node_netstat_IpExt_InOctets|untyped|Statistic IpExtInOctets.|
|node_netstat_IpExt_OutOctets|untyped|Statistic IpExtOutOctets.|
|node_netstat_Ip_Forwarding|untyped|Statistic IpForwarding.|
|node_netstat_TcpExt_ListenDrops|untyped|Statistic TcpExtListenDrops.|
|node_netstat_TcpExt_ListenOverflows|untyped|Statistic TcpExtListenOverflows.|
|node_netstat_TcpExt_SyncookiesFailed|untyped|Statistic TcpExtSyncookiesFailed.|
|node_netstat_TcpExt_SyncookiesRecv|untyped|Statistic TcpExtSyncookiesRecv.|
|node_netstat_TcpExt_SyncookiesSent|untyped|Statistic TcpExtSyncookiesSent.|
|node_netstat_TcpExt_TCPSynRetrans|untyped|Statistic TcpExtTCPSynRetrans.|
|node_netstat_Tcp_ActiveOpens|untyped|Statistic TcpActiveOpens.|
|node_netstat_Tcp_CurrEstab|untyped|Statistic TcpCurrEstab.|
|node_netstat_Tcp_InErrs|untyped|Statistic TcpInErrs.|
|node_netstat_Tcp_InSegs|untyped|Statistic TcpInSegs.|
|node_netstat_Tcp_OutSegs|untyped|Statistic TcpOutSegs.|
|node_netstat_Tcp_PassiveOpens|untyped|Statistic TcpPassiveOpens.|
|node_netstat_Tcp_RetransSegs|untyped|Statistic TcpRetransSegs.|
|node_netstat_Udp6_InDatagrams|untyped|Statistic Udp6InDatagrams.|
|node_netstat_Udp6_InErrors|untyped|Statistic Udp6InErrors.|
|node_netstat_Udp6_NoPorts|untyped|Statistic Udp6NoPorts.|
|node_netstat_Udp6_OutDatagrams|untyped|Statistic Udp6OutDatagrams.|
|node_netstat_Udp6_RcvbufErrors|untyped|Statistic Udp6RcvbufErrors.|
|node_netstat_Udp6_SndbufErrors|untyped|Statistic Udp6SndbufErrors.|
|node_netstat_UdpLite6_InErrors|untyped|Statistic UdpLite6InErrors.|
|node_netstat_UdpLite_InErrors|untyped|Statistic UdpLiteInErrors.|
|node_netstat_Udp_InDatagrams|untyped|Statistic UdpInDatagrams.|
|node_netstat_Udp_InErrors|untyped|Statistic UdpInErrors.|
|node_netstat_Udp_NoPorts|untyped|Statistic UdpNoPorts.|
|node_netstat_Udp_OutDatagrams|untyped|Statistic UdpOutDatagrams.|
|node_netstat_Udp_RcvbufErrors|untyped|Statistic UdpRcvbufErrors.|
|node_netstat_Udp_SndbufErrors|untyped|Statistic UdpSndbufErrors.|
|node_network_address_assign_type|gauge|address_assign_type value of /sys/class/net/<iface>.|
|node_network_carrier|gauge|carrier value of /sys/class/net/<iface>.|
|node_network_carrier_changes_total|counter|carrier_changes_total value of /sys/class/net/<iface>.|
|node_network_device_id|gauge|device_id value of /sys/class/net/<iface>.|
|node_network_dormant|gauge|dormant value of /sys/class/net/<iface>.|
|node_network_flags|gauge|flags value of /sys/class/net/<iface>.|
|node_network_iface_id|gauge|iface_id value of /sys/class/net/<iface>.|
|node_network_iface_link|gauge|iface_link value of /sys/class/net/<iface>.|
|node_network_iface_link_mode|gauge|iface_link_mode value of /sys/class/net/<iface>.|
|node_network_info|gauge|Non-numeric data from /sys/class/net/<iface>, value is always 1.|
|node_network_mtu_bytes|gauge|mtu_bytes value of /sys/class/net/<iface>.|
|node_network_net_dev_group|gauge|net_dev_group value of /sys/class/net/<iface>.|
|node_network_protocol_type|gauge|protocol_type value of /sys/class/net/<iface>.|
|node_network_receive_bytes_total|counter|Network device statistic receive_bytes.|
|node_network_receive_compressed_total|counter|Network device statistic receive_compressed.|
|node_network_receive_drop_total|counter|Network device statistic receive_drop.|
|node_network_receive_errs_total|counter|Network device statistic receive_errs.|
|node_network_receive_fifo_total|counter|Network device statistic receive_fifo.|
|node_network_receive_frame_total|counter|Network device statistic receive_frame.|
|node_network_receive_multicast_total|counter|Network device statistic receive_multicast.|
|node_network_receive_packets_total|counter|Network device statistic receive_packets.|
|node_network_speed_bytes|gauge|speed_bytes value of /sys/class/net/<iface>.|
|node_network_transmit_bytes_total|counter|Network device statistic transmit_bytes.|
|node_network_transmit_carrier_total|counter|Network device statistic transmit_carrier.|
|node_network_transmit_colls_total|counter|Network device statistic transmit_colls.|
|node_network_transmit_compressed_total|counter|Network device statistic transmit_compressed.|
|node_network_transmit_drop_total|counter|Network device statistic transmit_drop.|
|node_network_transmit_errs_total|counter|Network device statistic transmit_errs.|
|node_network_transmit_fifo_total|counter|Network device statistic transmit_fifo.|
|node_network_transmit_packets_total|counter|Network device statistic transmit_packets.|
|node_network_transmit_queue_length|gauge|transmit_queue_length value of /sys/class/net/<iface>.|
|node_network_up|gauge|Value is 1 if operstate is 'up', 0 otherwise.|
|node_nfs_connections_total|counter|Total number of NFSd TCP connections.|
|node_nfs_packets_total|counter|Total NFSd network packets (sent+received) by protocol type.|
|node_nfs_requests_total|counter|Number of NFS procedures invoked.|
|node_nfs_rpc_authentication_refreshes_total|counter|Number of RPC authentication refreshes performed.|
|node_nfs_rpc_retransmissions_total|counter|Number of RPC transmissions performed.|
|node_nfs_rpcs_total|counter|Total number of RPCs performed.|
|node_procs_blocked|gauge|Number of processes blocked waiting for I/O to complete.|
|node_procs_running|gauge|Number of processes in runnable state.|
|node_rapl_dram_joules_total|counter|Current RAPL dram value in joules|
|node_rapl_package_joules_total|counter|Current RAPL package value in joules|
|node_schedstat_running_seconds_total|counter|Number of seconds CPU spent running a process.|
|node_schedstat_timeslices_total|counter|Number of timeslices executed by CPU.|
|node_schedstat_waiting_seconds_total|counter|Number of seconds spent by processing waiting for this CPU.|
|node_scrape_collector_duration_seconds|gauge|node_exporter: Duration of a collector scrape.|
|node_scrape_collector_success|gauge|node_exporter: Whether a collector succeeded.|
|node_sockstat_FRAG6_inuse|gauge|Number of FRAG6 sockets in state inuse.|
|node_sockstat_FRAG6_memory|gauge|Number of FRAG6 sockets in state memory.|
|node_sockstat_FRAG_inuse|gauge|Number of FRAG sockets in state inuse.|
|node_sockstat_FRAG_memory|gauge|Number of FRAG sockets in state memory.|
|node_sockstat_RAW6_inuse|gauge|Number of RAW6 sockets in state inuse.|
|node_sockstat_RAW_inuse|gauge|Number of RAW sockets in state inuse.|
|node_sockstat_TCP6_inuse|gauge|Number of TCP6 sockets in state inuse.|
|node_sockstat_TCP_alloc|gauge|Number of TCP sockets in state alloc.|
|node_sockstat_TCP_inuse|gauge|Number of TCP sockets in state inuse.|
|node_sockstat_TCP_mem|gauge|Number of TCP sockets in state mem.|
|node_sockstat_TCP_mem_bytes|gauge|Number of TCP sockets in state mem_bytes.|
|node_sockstat_TCP_orphan|gauge|Number of TCP sockets in state orphan.|
|node_sockstat_TCP_tw|gauge|Number of TCP sockets in state tw.|
|node_sockstat_UDP6_inuse|gauge|Number of UDP6 sockets in state inuse.|
|node_sockstat_UDPLITE6_inuse|gauge|Number of UDPLITE6 sockets in state inuse.|
|node_sockstat_UDPLITE_inuse|gauge|Number of UDPLITE sockets in state inuse.|
|node_sockstat_UDP_inuse|gauge|Number of UDP sockets in state inuse.|
|node_sockstat_UDP_mem|gauge|Number of UDP sockets in state mem.|
|node_sockstat_UDP_mem_bytes|gauge|Number of UDP sockets in state mem_bytes.|
|node_sockstat_sockets_used|gauge|Number of IPv4 sockets in use.|
|node_softnet_dropped_total|counter|Number of dropped packets|
|node_softnet_processed_total|counter|Number of processed packets|
|node_softnet_times_squeezed_total|counter|Number of times processing packets ran out of quota|
|node_textfile_scrape_error|gauge|1 if there was an error opening or reading a file, 0 otherwise|
|node_time_seconds|gauge|System time in seconds since epoch (1970).|
|node_timex_estimated_error_seconds|gauge|Estimated error in seconds.|
|node_timex_frequency_adjustment_ratio|gauge|Local clock frequency adjustment.|
|node_timex_loop_time_constant|gauge|Phase-locked loop time constant.|
|node_timex_maxerror_seconds|gauge|Maximum error in seconds.|
|node_timex_offset_seconds|gauge|Time offset in between local system and reference clock.|
|node_timex_pps_calibration_total|counter|Pulse per second count of calibration intervals.|
|node_timex_pps_error_total|counter|Pulse per second count of calibration errors.|
|node_timex_pps_frequency_hertz|gauge|Pulse per second frequency.|
|node_timex_pps_jitter_seconds|gauge|Pulse per second jitter.|
|node_timex_pps_jitter_total|counter|Pulse per second count of jitter limit exceeded events.|
|node_timex_pps_shift_seconds|gauge|Pulse per second interval duration.|
|node_timex_pps_stability_exceeded_total|counter|Pulse per second count of stability limit exceeded events.|
|node_timex_pps_stability_hertz|gauge|Pulse per second stability, average of recent frequency changes.|
|node_timex_status|gauge|Value of the status array bits.|
|node_timex_sync_status|gauge|Is clock synchronized to a reliable server (1 = yes, 0 = no).|
|node_timex_tai_offset_seconds|gauge|International Atomic Time (TAI) offset.|
|node_timex_tick_seconds|gauge|Seconds between clock ticks.|
|node_udp_queues|gauge|Number of allocated memory in the kernel for UDP datagrams in bytes.|
|node_uname_info|gauge|Labeled system information as provided by the uname system call.|
|node_vmstat_pgfault|untyped|/proc/vmstat information field pgfault.|
|node_vmstat_pgmajfault|untyped|/proc/vmstat information field pgmajfault.|
|node_vmstat_pgpgin|untyped|/proc/vmstat information field pgpgin.|
|node_vmstat_pgpgout|untyped|/proc/vmstat information field pgpgout.|
|node_vmstat_pswpin|untyped|/proc/vmstat information field pswpin.|
|node_vmstat_pswpout|untyped|/proc/vmstat information field pswpout.|
|node_xfs_allocation_btree_compares_total|counter|Number of allocation B-tree compares for a filesystem.|
|node_xfs_allocation_btree_lookups_total|counter|Number of allocation B-tree lookups for a filesystem.|
|node_xfs_allocation_btree_records_deleted_total|counter|Number of allocation B-tree records deleted for a filesystem.|
|node_xfs_allocation_btree_records_inserted_total|counter|Number of allocation B-tree records inserted for a filesystem.|
|node_xfs_block_map_btree_compares_total|counter|Number of block map B-tree compares for a filesystem.|
|node_xfs_block_map_btree_lookups_total|counter|Number of block map B-tree lookups for a filesystem.|
|node_xfs_block_map_btree_records_deleted_total|counter|Number of block map B-tree records deleted for a filesystem.|
|node_xfs_block_map_btree_records_inserted_total|counter|Number of block map B-tree records inserted for a filesystem.|
|node_xfs_block_mapping_extent_list_compares_total|counter|Number of extent list compares for a filesystem.|
|node_xfs_block_mapping_extent_list_deletions_total|counter|Number of extent list deletions for a filesystem.|
|node_xfs_block_mapping_extent_list_insertions_total|counter|Number of extent list insertions for a filesystem.|
|node_xfs_block_mapping_extent_list_lookups_total|counter|Number of extent list lookups for a filesystem.|
|node_xfs_block_mapping_reads_total|counter|Number of block map for read operations for a filesystem.|
|node_xfs_block_mapping_unmaps_total|counter|Number of block unmaps (deletes) for a filesystem.|
|node_xfs_block_mapping_writes_total|counter|Number of block map for write operations for a filesystem.|
|node_xfs_directory_operation_create_total|counter|Number of times a new directory entry was created for a filesystem.|
|node_xfs_directory_operation_getdents_total|counter|Number of times the directory getdents operation was performed for a filesystem.|
|node_xfs_directory_operation_lookup_total|counter|Number of file name directory lookups which miss the operating systems directory name lookup cache.|
|node_xfs_directory_operation_remove_total|counter|Number of times an existing directory entry was created for a filesystem.|
|node_xfs_extent_allocation_blocks_allocated_total|counter|Number of blocks allocated for a filesystem.|
|node_xfs_extent_allocation_blocks_freed_total|counter|Number of blocks freed for a filesystem.|
|node_xfs_extent_allocation_extents_allocated_total|counter|Number of extents allocated for a filesystem.|
|node_xfs_extent_allocation_extents_freed_total|counter|Number of extents freed for a filesystem.|
|node_xfs_read_calls_total|counter|Number of read(2) system calls made to files in a filesystem.|
|node_xfs_vnode_active_total|counter|Number of vnodes not on free lists for a filesystem.|
|node_xfs_vnode_allocate_total|counter|Number of times vn_alloc called for a filesystem.|
|node_xfs_vnode_get_total|counter|Number of times vn_get called for a filesystem.|
|node_xfs_vnode_hold_total|counter|Number of times vn_hold called for a filesystem.|
|node_xfs_vnode_reclaim_total|counter|Number of times vn_reclaim called for a filesystem.|
|node_xfs_vnode_release_total|counter|Number of times vn_rele called for a filesystem.|
|node_xfs_vnode_remove_total|counter|Number of times vn_remove called for a filesystem.|
|node_xfs_write_calls_total|counter|Number of write(2) system calls made to files in a filesystem.|
|process_cpu_seconds_total|counter|Total user and system CPU time spent in seconds.|
|process_max_fds|gauge|Maximum number of open file descriptors.|
|process_open_fds|gauge|Number of open file descriptors.|
|process_resident_memory_bytes|gauge|Resident memory size in bytes.|
|process_start_time_seconds|gauge|Start time of the process since unix epoch in seconds.|
|process_virtual_memory_bytes|gauge|Virtual memory size in bytes.|
|process_virtual_memory_max_bytes|gauge|Maximum amount of virtual memory available in bytes.|
|promhttp_metric_handler_errors_total|counter|Total number of internal errors encountered by the promhttp metric handler.|
|promhttp_metric_handler_requests_in_flight|gauge|Current number of scrapes being served.|
|promhttp_metric_handler_requests_total|counter|Total number of scrapes by HTTP status code.|
