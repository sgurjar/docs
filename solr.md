Title: Solr Notes
Date: 2012-03-01

`{SOLR_HOME}/conf/solrconfig.xml`
--------------------------------

* `<abortOnConfigurationError>`
* `<luceneMatchVersion>`
* `<lib>` directives can be used to instruct Solr to load an Jars identified and
  use them to resolve any "plugins" specified in your solrconfig.xml or
  schema.xml (ie: Analyzers, Request Handlers, etc...)
* `<dataDir>` specify an alternate directory to hold all index data other
  than the default ./data under the Solr home.
* `<directoryFactory>` The DirectoryFactory to use for indexes.
  `solr.StandardDirectoryFactory`, the default, is filesystem based and tries
  to pick the best implementation for the current JVM and platform.
* `<indexDefaults>` Values here affect all index writers and act as a default
  unless overridden.
    - `<useCompoundFile>`
    - `<mergeFactor>`
    - `<ramBufferSizeMB>` Sets the amount of RAM that may be used by Lucene
    indexing for buffering added documents and deletions before they are
    flushed to the Directory.
    - `<maxFieldLength>`
    - `<writeLockTimeout>`
    - `<mergePolicy>` The Merge Policy in Lucene controls how merging is handled
    by Lucene. The default in Solr 3.3 is TieredMergePolicy.
    - `<mergeScheduler>` The Merge Scheduler in Lucene controls how merges are
    performed. The ConcurrentMergeScheduler (Lucene 2.3 default) can perform
    merges in the background using separate threads.
    - `<lockType>` which Lucene LockFactory implementation to use.
        + single = `SingleInstanceLockFactory` - suggested for a
              read-only index or when there is no possibility of
              another process trying to modify the index.
        + native = `NativeFSLockFactory` - uses OS native file locking.
              Do not use when multiple solr webapps in the same
              JVM are attempting to share a single index.
        + simple = `SimpleFSLockFactory` - uses a plain file for locking
* `<mainIndex>` Values here override the values in the `<indexDefaults>` section
  for the main on disk index.
    - `<useCompoundFile>`
    - `<ramBufferSizeMB>`
    - `<mergeFactor>`
    - `<unlockOnStartup>` If true, unlock any held write or commit locks on startup.
      This defeats the locking mechanism that allows multiple processes to
      safely access a lucene index
    - `<reopenReaders>` If true, IndexReaders will be reopened (often more efficient)
      instead of closed and then opened.
    - `<deletionPolicy>`
        + `maxCommitsToKeep` The number of commit points to be kept
        + `maxOptimizedCommitsToKeep` The number of optimized commit points to be kept
        + `maxCommitAge`, `maxCommitAge` Delete all commit points once they have reached the given age.
    - `<infoStream>` To aid in advanced debugging, Lucene provides an "InfoStream" of detailed information when indexing.
* `<jmx>`
    - `agentId` to connect to a particular server, specify the agentId
    - `serviceUrl` to start a new MBeanServer, specify the serviceUrl
* `<updateHandler>` The default, `solr.DirectUpdateHandler2`, high-performance update handler
    - `<autoCommit>` `maxDocs`, `maxTime` Perform a `<commit/>` automatically. Instead
    of enabling autoCommit, consider using "commitWithin" when adding documents.
    - `<listener>` Various IndexWriter related events can trigger Listeners to take actions.
        + postCommit - fired after every commit or optimize command
        + postOptimize - fired after every optimize command
        + class `RunExecutableListener` executes an external command from a hook such as postCommit or postOptimize.
            - exe - the name of the executable to run
            - dir - dir to use as the current working directory. (default=".")
            - wait - the calling thread waits until the executable returns. (default="true")
            - args - the arguments to pass to the program.  (default is none)
            - env - environment variables to set.  (default is none)
* `<indexReaderFactory>` alternate IndexReader implementations *Experimental Feature*
* `<query>`
    - `<maxBooleanClauses>` Maximum number of clauses in each BooleanQuery, an exception is thrown if exceeded.
    - `<filterCache>` Cache used by SolrIndexSearcher for filters (DocSets), `solr.FastLRUCache`
    - `<queryResultCache>` Caches results of searches - ordered lists of document ids (DocList) based on a query, a sort, and the range of documents requested.
    - `<documentCache>` Caches Lucene Document objects (the stored fields for each document).
    - `<fieldValueCache>` Cache used to hold field values that are quickly accessible by document id. not configured by default
    - `<cache>` Custom Cache to enable easy caching of user/application level data.
    - `<enableLazyFieldLoading>` Lazy Field Loading. If true, stored fields that are not requested will be loaded lazily.
    - `<useFilterForSortedQuery>` A possible optimization that attempts to use a filter to satisfy a search. not set by default
    - `<queryResultWindowSize>` An optimization for use with the queryResultCache.
    - `<queryResultMaxDocsCached>` Maximum number of documents to cache for any entry in the queryResultCache.
    - `<useColdSearcher>` If a search request comes in and there is no current registered searcher, then immediately register the still warming searcher and use it.
    - `<maxWarmingSearchers>` Maximum number of searchers that may be warming in the background concurrently.
* `<requestDispatcher>` how the `SolrDispatchFilter` should behave when processing requests for this SolrCore.
    - `<requestParsers>` how Solr Requests may be parsed, and what restrictions may be placed on the ContentStreams from those requests
    - `<httpCaching>` HTTP caching related parameters (for proxy caches and clients).
* `<requestHandler>` processing Search Queries, the primary Request Handler provided with Solr is "SearchHandler" It delegates to a sequent of SearchComponents and supports distributed queries across multiple shards
    - solr.SearchHandler
    - solr.XmlUpdateRequestHandler
    - solr.BinaryUpdateRequestHandler
    - solr.CSVRequestHandler
    - solr.JsonUpdateRequestHandler
    - solr.extraction.ExtractingRequestHandler
    - solr.XsltUpdateRequestHandler
    - solr.FieldAnalysisRequestHandler
    - solr.DocumentAnalysisRequestHandler
    - solr.admin.AdminHandlers
    - solr.PingRequestHandler
    - solr.DumpRequestHandler
* `<searchComponent>`
    - solr.SpellCheckComponent
    - solr.TermVectorComponent
    - solr.clustering.ClusteringComponent
    - solr.TermsComponent
    - solr.QueryElevationComponent
    - solr.HighlightComponent
* `<queryResponseWriter>`

