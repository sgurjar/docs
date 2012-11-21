Title:Apache Lucene
Date:2011-11-18

Indexing
--------------------------------------------------------------------------------

* Adding documents to an index

        /*
          #A Run before every test
          #B Create index
          #C Add documents
          #D Create IndexWriter
          #E Create new searcher
          #F Build simple single-term query
          #G Get number of hits
          #H Verify writer document count
          #I Verify searcher document count
        */
        public class IndexingTest extends TestCase {
            protected String[] ids = {"1", "2"};
            protected String[] unindexed = {"Netherlands", "Italy"};
            protected String[] unstored = {"Amsterdam has lots of bridges",
                                           "Venice has lots of canals"
                                          };
            protected String[] text = {"Amsterdam", "Venice"};
            private Directory directory;
            protected void setUp() throws Exception { //A
                directory = new RAMDirectory();
                IndexWriter writer = getWriter(); //B
                    //C adding 2 documents
                for (int i = 0; i < ids.length; i++) {
                    Document doc = new Document();
                    doc.add(new Field("id", ids[i],
                        Field.Store.YES, Field.Index.NOT_ANALYZED));
                    doc.add(new Field("country", unindexed[i],
                        Field.Store.YES, Field.Index.NO));
                    doc.add(new Field("contents", unstored[i],
                        Field.Store.NO , Field.Index.ANALYZED));
                    doc.add(new Field("city", text[i],
                        Field.Store.YES, Field.Index.ANALYZED));
                    writer.addDocument(doc);
                }
                writer.close();
            }
            private IndexWriter getWriter() throws IOException { // D
                return new IndexWriter(
                        // where the index is stored
                  directory,
                        // analyzer to use when indexing tokenized fields
                  new WhitespaceAnalyzer(),
                        // index all tokens in the document
                  IndexWriter.MaxFieldLength.UNLIMITED
                  );
                // IndexWriter will detect that there's no prior index
                // in this Directory and create a new one.
            }
            protected int getHitCount(String fieldName, String searchString)
              throws IOException {
                IndexSearcher searcher = new IndexSearcher(directory); //E
                Term t = new Term(fieldName, searchString);
                Query query = new TermQuery(t); //F
                int hitCount = searcher.search(query, 1).totalHits; //G
                searcher.close();
                return hitCount;
            }
            public void testIndexWriter() throws IOException {
                IndexWriter writer = getWriter();
                assertEquals(ids.length, writer.numDocs()); //H
                writer.close();
            }
            public void testIndexReader() throws IOException {
                IndexReader reader = IndexReader.open(directory);
                assertEquals(ids.length, reader.maxDoc()); //I
                assertEquals(ids.length, reader.numDocs()); //I
                reader.close();
            }
        }

* \#A The `setUp()` method first creates a new `RAMDirectory`, to hold the index.
* \#B, \#D Next, it creates an `IndexWriter` on this Directory. We created the
`getWriter` convenience method since we need to get the `IndexWriter` in many places.
* \#C Finally, `setUp()` iterates over our content, creating `Document` and `Fields`
and then adds the `Document` to the index.
* \#E, \#F, \#G We create the `IndexSearcher` and a basic single term query
and then verify the hit count is correct.

### Steps for adding document to a (new or existing) index--
1. create a new empty Document
2. one by one we add each Field we'd like to have on the document
3. call `writer.addDocument` to index the document

### Steps for deleting document from a index--
`IndexWriter` provides various methods to remove documents from an index:

* `deleteDocuments(Term)` deletes all documents containing the provided term.
* `deleteDocuments(Term[])` deletes all documents containing any of the terms in the provided array.
* `deleteDocuments(Query)` deletes all documents matching the provided query.
* `deleteDocuments(Query[])` deletes all documents matching any of the queries in the provided array.

If you intend to delete a single document by Term, you must ensure you've
indexed a Field on every document, and that all Field values are unique so
that each document can be singled out for deletion. This is the same concepts
as a primary key column in a database table. This field should be indexed as
an **un-analyzed field** to ensure the analyzer does not break it up into
separate tokens. Then, use the field for document deletion like this:

        writer.deleteDocument(new Term("ID", documentID));

As with added documents, you must call `commit()` or `close()` on your writer to
commit the changes to the index.

    /*
    #1 2 docs in the index
    #2 Delete first document
    #3 Index contains deletions
    #4 1 indexed document, 1 deleted document
    #5 Optimize compacts deletes
    #6 1 indexed document, 0 deleted documents
    */
    public void testDeleteBeforeIndexMerge() throws IOException {
        IndexWriter writer = getWriter();
        assertEquals(2, writer.numDocs()); //1
        writer.deleteDocuments(new Term("id", "1")); //2
        writer.commit();
        assertTrue(writer.hasDeletions()); //3
        assertEquals(2, writer.maxDoc()); //4
        assertEquals(1, writer.numDocs()); //4
        writer.close();
    }

    public void testDeleteAfterIndexMerge() throws IOException {
        IndexWriter writer = getWriter();
        assertEquals(2, writer.numDocs());
        writer.deleteDocuments(new Term("id", "1"));
        writer.optimize(); //5
        writer.commit();
        assertFalse(writer.hasDeletions());
        assertEquals(1, writer.maxDoc()); //6
        assertEquals(1, writer.numDocs()); //6
        writer.close();
    }

`maxDoc()` and `numDocs()` methods in `IndexWriter` and `IndexReader`.

* `maxDoc()` returns the total number of **deleted** and **un-deleted** documents in the index
* `numDocs()` returns only the number of **un-deleted** documents.

### Updating document in an index--

Lucene cannot update part of document: instead, it deletes the entire previous
document and then adds a new document to the index. This requires that the new
document contains all fields, even unchanged ones, from the original document.

`IndexWriter` provides two convenience methods to replace a document in the index:

* `updateDocument(Term, Document)` first deletes all documents containing the
provided term and then adds the new document using the writer's default analyzer.
* `updateDocument(Term, Document, Analyzer)` does the same, but uses the provided
analyzer instead of the writer's default analyzer.

*Note* that these methods are simply shorthand for first calling
`deleteDocument(Term)` and then `addDocument`.

    /*
    #1 Create new document with "Haag" in city field
    #2 Replace original document with new version
    #3 Verify old document is gone
    #4 Verify new document is indexed
    */
    public void testUpdate() throws IOException {
        assertEquals(1, getHitCount("city", "Amsterdam"));
        IndexWriter writer = getWriter();
        Document doc = new Document(); //1
        doc.add(new Field("id", "1",
            Field.Store.YES, Field.Index.NOT_ANALYZED)); //1
        doc.add(new Field("country", "Netherlands",
            Field.Store.YES, Field.Index.NO)); //1
        doc.add(new Field("contents", "Amsterdam has lots of bridges",
            Field.Store.NO , Field.Index.ANALYZED)); //1
        doc.add(new Field("city", "Haag",
            Field.Store.YES, Field.Index.ANALYZED)); //1
        writer.updateDocument(new Term("id", "1"), doc); //2
        writer.close();
        assertEquals(0, getHitCount("city", "Amsterdam"));//3
        assertEquals(1, getHitCount("city", "Haag")); //4
    }

### Field

class that holds each value to be indexed. Field options are used to specify
what Lucene should do with that field once added the document to the index.

### Field options for indexing
options for indexing (`Field.Index.*`) control how the text in the field will be
made searchable via the inverted index.

* `Index.ANALYZED` - use the analyzer to break the Field's value into a stream of
separate tokens and make each token searchable. This is useful for normal text
fields (body, title, abstract, etc.).

* `Index.NOT_ANALYZED` - do index the field, but do not analyze the String.
Instead, treat the Field's entire value as a single token and make that token
searchable. This is useful for fields that you would like to search on, but
should not be broken up, such as URLs, file system paths, dates,
personal names, Social Security numbers, telephone numbers, and so on.
This is especially useful for enabling "exact match" searching.

* `Index.ANALYZED_NO_NORMS` - an advanced variant of `Index.ANALYZED` which does
not store *norms* information in the index. *Norms* record boost information in
the index, but can be memory consuming when searching.

* `Index.NOT_ANALYZED_NO_NORMS` - but also do not store Norms.

* `Index.NO` - don't make this field's value available for searching at all.


__`Field.setOmitTermFreqAndPositions(true)`__
When Lucene builds the inverted index, by default it stores all necessary
information to implement the Vector Space model. This model requires the
count of every term that occurred in the document, as well as the positions of
each occurrence (needed for phrase searches). However, sometimes you know the
field will be used only for pure Boolean searching and need not contribute to
the relevance score. `Fields` that are used only for filtering, such as
entitlements or date filtering, is a common example. In this case, you can
tell Lucene to skip indexing the term frequency and positions by calling
`Field.setOmitTermFreqAndPositions(true)`. This will save some disk space in
the index, and may also speed up searching and filtering, but will silently
prevent searches that require positional information, such as `PhraseQuery` and
`SpanQuery`, from working.

### Field options for storing fields
options for stored fields (`Field.Store.*`) determine whether the field's exact
value should be stored away so that you can later retrieve it during searching.

* `Store.YES` - store the value. When the value is stored, the original String
in its entirety is recorded in the index and may be retrieved by an `IndexReader`.
This is useful for fields that you'd like to use when displaying the search
results (such as a URL, title or database primary key). Try not to store very
large fields, if index size is a concern, as stored fields consume space in the index.

* `Store.NO` - do not store the value. This is often used along with `Index.ANALYZED`
to index a large text field that doesn't need to be retrieved in its original form,
such as bodies of web pages, or any other type of text document.

Lucene includes a helpful utility class, CompressionTools, that can compress
and decompress byte arrays. Under the hood it simply uses Java's builtin
`java.util.Zip` classes. You can use this to compress values before storing
them in Lucene. _Note_ that while this will save space in your index, depending
on how compressible the content is, it will slow down indexing and searching.
If the field values are small, compression is rarely worthwhile.

### Field options for term vectors
Term vectors are something a mix of between an indexed field and a stored field.
They are similar to a stored field because you can quickly retrieve all term vector
fields for a given document: term vectors are keyed first by document ID. But then,
they are keyed secondarily by term, meaning they store a miniature inverted
index for that one document. Unlike a stored field, where the original String
content is stored verbatim, term vectors store the actual separate terms that were
produced by the Analyzer. This allows you to retrieve all terms, and the
frequency of their occurrence within the document and sorted in lexicographic order,
for a particular indexed Field of a particular Document. Since the tokens coming
out of an analyzer also have position and offset information, you can choose
separately whether these details are also stored in your term vectors by
passing these constants as the 4th argument to the Field constructor:

* `TermVector.YES` - record the unique terms that occurred, and their counts,
in each document, but do not store any positions or offsets information.

* `TermVector.WITH_POSITIONS` - record the unique terms and their counts, and also the
positions of each occurrence of every term, but no offsets.

* `TermVector.WITH_OFFSETS` - record the unique terms and their counts, with the offsets (start &
end character position) of each occurrence of every term, but no positions.

* `TermVector.WITH_POSITIONS_OFFSETS` - store unique terms and their counts, along with
positions and offsets.

* `TermVector.NO` - do not store any term vector information.

_Note_ that you cannot index term vectors unless you've also turned on indexing
for the field. __if `Index.NO` is specified for a field, then you must also
specify `TermVector.NO`.__

### Other Field values

* `Field(String name, Reader value, TermVector vector)` uses a `Reader` instead of a
`String` to represent the value. In this case the value cannot be stored
(hardwired to `Store.NO`) and is always analyzed and indexed (`Index.ANALYZED`).

* `Field(String name, TokenStream tokenStream, TermVector TermVector)` allows you
to pre-analyze the field value into a `TokenStream`. Likewise, such fields are
not stored and are always analyzed and indexed.

* `Field(String name, byte[] value, Store store)` is used to store a binary field.
Such fields are never indexed (`Index.NO`), and have no term vectors
(`TermVector.NO`). The store argument must be `Store.YES`.

### Field option combinations in practice

<pre class="table">
       Index        Store Term Vector              Example Usage
     __________________________________________________________________________
      NOT_ANALYZED YES    NO                      Identifiers (file names,
                                                  primary keys)], Telephone and
                                                  Social Security numbers, URLs,
                                                  personal names, Dates

      ANALYZED     YES    WITH_POSITIONS_OFFSETS  Document title, document
                                                  abstract

      ANALYZED     NO     WITH_POSITIONS_OFFSETS  Document body

      NO           YES    NO                      Document type, database
                                                  primary key (if not used for
                                                  searching)

      NOT_ANALYZED NO     NO                      Hidden keywords
</pre>

### Multi-valued Fields

    Document doc = new Document();
    for (int i = 0; i < authors.length; i++) {
        doc.add(new Field("author", authors[i],
                            Field.Store.YES,
                            Field.Index.ANALYZED));
    }

add same field with multiple values as multiple fields as same name.
whenever multiple fields with the same name appear in one document,
both the inverted index and term vectors will logically append the
tokens of the field to one another, in the order the fields were added.

### Boosting Documents and Fields
Boosting document or fields provides them more important in search results.
By default, all Documents have the same boost factor of 1.0.

    #1 Good domain boost factor: 1.5
    #2 Bad domain boost factor: 0.1

    public static final String COMPANY_DOMAIN = "example.com";
    public static final String BAD_DOMAIN = "yucky-domain.com";

    Document doc = new Document();
    String senderEmail = getSenderEmail();
    String senderName = getSenderName();
    String subject = getSubject();
    String body = getBody();
    doc.add(new Field("senderEmail", senderEmail,
                    Field.Store.YES,
                    Field.Index.NOT_ANALYZED));
    doc.add(new Field("senderName", senderName,
                    Field.Store.YES,
                    Field.Index.ANALYZED));
    doc.add(new Field("subject", subject,
                    Field.Store.YES,
                    Field.Index.ANALYZED));
    doc.add(new Field("body", body,
                    Field.Store.NO,
                    Field.Index.ANALYZED));
    String lowerDomain = getSenderDomain().toLowerCase();
    if (isImportant(lowerDomain)) {
        doc.setBoost(1.5F); //1 increase boost factor
    }
    else if (isUnimportant(lowerDomain)) {
        doc.setBoost(0.1F); //2 reduce boost factor
    }
    writer.addDocument(doc);

You can also boost individual Fields. When you boost a Document, Lucene
internally uses the same boost factor to boost each of its Fields. For example,
in a email search, search matches made in the subject Field should be more
valuable than equivalent matches in the senderName Field.

    Field senderNameField = new Field("senderName", senderName,
                                    Field.Store.YES,
                                    Field.Index.ANALYZED);
    Field subjectField = new Field("subject", subject,
                                    Field.Store.YES,
                                    Field.Index.ANALYZED);
    subjectField.setBoost(1.2F);

*Shorter Fields have an implicit boost associated with them, due to the way
Lucene's scoring algorithm works.*

### Norms
During indexing, all sources of index-time boosts are combined together into a
single floating point number for each indexed field in the document.

The document may have its own boost; each field may have a boost; finally,
Lucene computes a boost based on the number of tokens in the field (shorter fields
have a higher boost). These boosts are combined and then compactly encoded
(quantized) into a single byte, which is stored per field per document.

During searching, norms for any field being searched are loaded into memory,
decoded back into a floating point number and used to compute the relevance score.

One problem often encountered with norms is that their high memory usage at
search time. This is because the full array of norms, which requires one byte
per document per separate field searched, is loaded into RAM. For a large index
with many fields per document, this can quickly add up to a lot of RAM.

### Indexing dates & times

Add date field to a document.

    Document doc = new Document();
    doc.add(new Field("indexDate",
    DateTools.dateToString(new Date(), DateTools.Resolution.DAY),
                                Field.Store.YES,
                                Field.Index.NOT_ANALYZED);

DateTools formats the date and time in the format YYYYMMDDhhmmss, stripping off
the suffix when you don't require that much resolution. For example, if you
use Resolution.DAY, then June 2 1970 will be converted to the string 19700602.

The resolution argument allows you to specify what parts of the date are
significant to your application, ranging from Resolution.MILLISECOND up
to Resolution.YEAR.

_NOTE_
If you only need the date for searching, and not the timestamp, index as

    new Field("date", "YYYYMMDD", Field.Store.YES, Field.Index.NOT_ANALYZED)

If the full timestamp needs to be preserved, but only for retrieval and
presentation (not searching), index a second Field using the finer resolution.
This will enable far more efficient date-only searching while not losing the
time portion of the date for presentation.

A benefit of indexing dates in YYYYMMDD format is the ability to query by year
only, by year and month, or by exact year, month, and day. To query by year
only, use a `PrefixQuery` for YYYY, for example.

### Indexing numbers
When you want treat numbers as numbers and not as string. For examples in email
search size of the email message should be treated as number to do range queries.

Lucene can index numeric values by treating them as strings internally. If you
need to index numbers that appear in free-form text, the first thing you should
do is pick an Analyzer that doesn't discard numbers. `WhitespaceAnalyzer` and
`StandardAnalyzer` are two possible candidates. If you feed them a sentence
such as "Be sure to include Form 1099 in your tax return," they extract 1099
as a token and pass it on for indexing, allowing you to later search for 1099.
On the other hand, `SimpleAnalyzer` and `StopAnalyzer` discard numbers from
the token stream, which means the search for 1099 won't match any documents.
If in doubt, use [Luke](http://code.google.com/p/luke/) to check whether numbers
survived your analyzer and were added to the index.

Fields whose sole value is a number don't need to be analyzed, so they should
be indexed with `Field.Index.NOT_ANALYZED`.

Consider three numeric Fields whose values are 7, 71, and 20. Although their
natural order is 7, 20, 71, their lexicographical order is 20, 7, 71. simple
and common trick for solving this inconsistency is to prepad numeric Fields
with zeros, like this: 007, 020, 071.

_NOTE_
When you index Fields with numeric values, prefix them with zeros if you want
to use them for range queries.

### Indexing Fields for sorting

If you want to be able to sort results by a Field value, you must add it as a
Field that is indexed but not analyzed, using `Field.Index.NOT_ANALYZED`.
Fields used for sorting must be convertible to Integers, Floats, or Strings:

    new Field("size", "4096", Field.Store.YES, Field.Index.NOT_ANALYZED);
    new Field("price", "10.99", Field.Store.YES, Field.Index.NOT_ANALYZED);
    new Field("author", "Arthur C. Clark", Field.Store.YES, Field.Index.NOT_ANALYZED);

Although we've indexed numeric values as Strings, you can specify the correct
Field type (such as Integer or Long) at sort time

### Field truncation
You may want to index only the first 200 words of each document.

IndexWriter allows you to truncate per-Field indexing such that only the first
N terms are indexed for an analyzed field.

When you instantiate IndexWriter, you must pass in a MaxFieldLength instance expressing this limit.
MaxFieldLength provides two convenient default instances:

* `MaxFieldLength.UNLIMITED` which means _no truncation_ will take place, and
* `MaxFieldLength.LIMITED` which means fields are truncated at _10,000 terms_.

You can also instantiate `MaxFieldLength` with your own limit.

Truncating to `N` terms means that only the first `N` terms are available for
searching, and any text beyond the `Nth` term is completely ignored.

### Optimizing an index
merges many index segments down to one or a few segments.

`IndexWriter` exposes 4 methods to optimize:

* `optimize()` reduces the index to a single segment, not returning until the operation is finished.
* `optimize(int maxNumSegments)`, also known as "partial optimize", reduces the index to at
most. Typically, the final merge down to one segment is the most costly, so optimizing to say 5
segments should be quite a bit faster than optimizing down to 1 segment, allowing you to tradeoff
optimize time versus search speed.
* `optimize(boolean doWait)` is just like optimize, except if doWait is false then the call returns
immediately while the necessary merges take place in the background.
* `optimize(int maxNumSegments, boolean doWait)` is a partial optimize that runs in the
background if `doWait` is false.

_Optimizing only improves searching speed, not indexing speed._

### Other Directory Implementations

* __`FSDirectory`__ stores files in a real filesystem directory.
* __`RAMDirectory`__ all "files" in memory instead of on disk.
* __`MMapDirectory`__ memory-mapped files.
* __`NIOFSDirectory`__ it uses java's native io package (`java.nio.*`) when reading
from the files, which allows it to avoid locking that the normal FSDirectory
must do when multiple threads read from the same file. If your application has
many threads sharing a single searcher it's likely switching to `NIOFSDirectory`
will improve your query throughput. However, because of known problems with the
implementation of `java.nio.*` under Sun's JRE on Windows, `NIOFSDirectory`
offers no gains on that platform and is likely slower than `FSDirectory`.
On all other platforms it's likely faster.

_NOTE_- A 32 b   it JVM this requires that your total index size fits into the
available address space (ie, less than 4 GB)

### Concurrency, thread-safety, and locking issues

* Any number of `IndexReaders` may be open at once on a single index. It doesn't matter if these
readers are in the same JVM or multiple JVMs, or on the same computer or multiple computers.
Within a single JVM it's best for resource utilization and performance reasons to share a
single `IndexReader` instance for a given index using multiple threads. For instance, multiple
threads or processes may search the same index in parallel.

* Only a single writer may be open on an index at once. Lucene uses a write lock file to enforce this.
As soon as an `IndexWriter` is created, a write lock is obtained. Only when that `IndexWriter` is closed
is the write lock released. Note that if you use `IndexReader` to make changes to the index, for example
to change norms (section 2.6.1) or delete documents, then that `IndexReader` acts as a writer: it will
obtain the write lock on the first method that makes a change, only releasing it once closed.

* `IndexReaders` may be open even while a single `IndexWriter` is making changes to the index.
Each `IndexReader` will always show the index as of the point-in-time that it was opened. It will
not see any changes being done by the `IndexWriter`, until the writer commits and the reader is
re-opened.

* Any number of threads can share a single instance of `IndexReader` or `IndexWriter`. These
classes generally scale well as you add threads, assuming your hardware has concurrency,
because the amount of synchronized code inside these classes is kept to a minimum.

### Index locking
Multiple `IndexWriter` can not be open on same index directory. By default
Lucene uses file-based lock to protect IndexWriter from being open multiple times
, including across jvms. Following code displays, kind of exception client code
will get if try to open a `IndexWriter` locked directory.

    public class LockTest extends TestCase {

        private Directory dir;

        protected void setUp() throws IOException {
            String indexDir =
            System.getProperty("java.io.tmpdir", "tmp") +
            System.getProperty("file.separator") + "index";
            dir = FSDirectory.getDirectory(indexDir);
        }

        public void testWriteLock() throws IOException {
            IndexWriter writer1 = null;
            IndexWriter writer2 = null;
            try {
                writer1 = new IndexWriter(dir, new SimpleAnalyzer(),
                IndexWriter.MaxFieldLength.UNLIMITED);
                writer2 = new IndexWriter(dir, new SimpleAnalyzer(),
                IndexWriter.MaxFieldLength.UNLIMITED);
                fail("We should never reach this point");
            }
            catch (LockObtainFailedException e) {
                // #1 Expected exception: only one IndexWriter allowed on single index
                e.printStackTrace();
            }
            finally {
                writer1.close();
                assertNull(writer2);
            }
        }
    }

    STACK TRACE
    ===========
    org.apache.lucene.store.LockObtainFailedException: Lock obtain timed out:
    SimpleFSLock@/tmp/index/write.lock
        at org.apache.lucene.store.Lock.obtain(Lock.java:85)
        at org.apache.lucene.index.IndexWriter.init(IndexWriter.java:1094)

Lucene allows you to change your locking implementation: any subclass of
`LockFactory` can be set as your locking implementation by calling
`Directory.setLockFactory`. Be sure to call this before opening an
`IndexWriter` on that Directory instance.

<pre class="table">
        Locking Class Name                      Description
     __________________________________________________________________________
      SimpleFSLockFactory         This is the default locking for FSDirectory,
                                using the File.createNewFile API. Beware that
                                if the JVM crashes or IndexWriter is not closed
                                before the JVM exits, this may leave a leftover
                                write.lock file which you must manually remove.

      NativeFSLockFactory         Uses java.nio native OS locking, which will
                                never leave leftover lock files when the JVM
                                exits. However, this locking implementation may
                                not work correctly over certain shared file
                                systems, notably NFS.

      SingleInstanceLockFactory   Creates a lock entirely in memory. This is the
                                default locking implementation for RAMDirectory.
                                Use this when you know all IndexWriters will be
                                instantiated in a single JVM.

      NoLockFactory               Disables locking entirely. Be careful! Only use
                                this when you are absolutely certain that Lucene's
                                normal locking safeguard is not necessary, for
                                example when using a private RAMDirectory with
                                a single IndexWriter instance.
</pre>

`IndexReader` also exposes methods to delete documents. An IndexReader that is
performing deletions counts as a "writer". This means you are forced to close
any open IndexWriter before doing deletions with `IndexReader` and vice/versa.

Whene deleting a document, Lucene simply marked as deleted in a bit array, which
is a very quick operation, but the data corresponding to that document still
__consumes disk space__ in the index. This is necessary because in an inverted index,
a given document's terms are scattered all over the place, and it would be
impractical to try to reclaim that space when the document is deleted. It's not
until segments are merged, either by normal merging over time or by an explicit
call to `optimize`, that these bytes are reclaimed.

You can also call `expungeDeletes` to reclaim all disk space consumed by deleted
documents. This call merges any segments that have pending deletions, which
might be a somewhat lower cost operation than optimize.

### Buffering and flushing
When new Documents are added to a Lucene index, or deletions are pending, they're
initially buffered in memory instead of being immediately written to the disk.
Periodically, these changes are flushed to the index `Directory` as a _new segment_.

* `setRAMBufferSizeMB` flush when the buffer has consumed more than a pre-set amount of RAM
* `setMaxBufferedDocs` flush after a specific number of documents have been added
* `setMaxBufferedDeleteTerms` flush whenever the total number of buffered delete
 terms and queries exceeds a specified count

_NOTE_ `IndexWriter.DISABLE_AUTO_FLUSH` can be passed to any of these methods
to prevent flushing by that criterion.

By default, `IndexWriter` flushes only when RAM usage is 16 MB.

While an `IndexWriter` is making changes to the index, an `IndexReader` will not
see any of these changes until `commit()` or `close()` is called.

### ACID transactions and index consistency
[skipped]

### Merging
When an index has too many segments, `IndexWriter` selects some of the segments
and merges them into a single, large segment.

Merging has several benefits:

* __reduces the number of segments in the index__ once the merge completes, all
of the old segments are removed and a  single large segment is added in their place.
    1. makes searching faster since there are fewer segments to search
    2. prevents hitting the file descriptor limit enforced by the operating system.
* __reduces the size of the index__ if there were deletes pending on the merged
segments, the merging process frees up the bytes consumed by deleted documents.
Even if there are no pending deletions, a single merged segment will generally
use fewer bytes to represent exactly the same set of indexed documents.

MergePolicy

1. `LogByteSizeMergePolicy` _default_ measures the size of a segment as the
total size in bytes of all files for that segment.
2. `LogDocMergePolicy`  measures size of a segment by the document count
of the segment.

If the core merge policies don't suit your application, you can subclass
`MergePolicy` to implement your own.

MergeScheduler

Selection of a merge is only the first step. The next step is the actual
merging. `IndexWriter` relies on a subclass of `MergeScheduler` to achieve this.

* `ConcurrentMergeScheduler` __default__, which merges segments using background threads.
* `SerialMergeScheduler` merges segments using the same thread that's calling `addDocument`.

You could also implement your own `MergeScheduler`: perhaps you want to defer very
large segment merges until after 2 AM but do smaller merges whenever they are needed.

### Sharing an index over NFS (Networked File System)
[skipped]

### Debugging indexing

    IndexWriter writer = new IndexWriter(dir, new SimpleAnalyzer(),
        true, IndexWriter.MaxFieldLength.UNLIMITED);
    writer.setInfoStream(System.out); // print logs to stdout


Adding search to your application
--------------------------------------------------------------------------------


### Lucene's primary searching API

* `IndexSearcher`   All searches come through an IndexSearcher instance using
any of the several overloaded search methods.
* `Query` (and subclasses) Concrete subclasses encapsulate logic for a particular
query type. Instances of `Query` are passed to an `IndexSearcher`'s search method.
* `QueryParser` Processes a human-entered (and readable) expression into a
concrete Query object.
* `TopDocs` Holds the top scoring documents, returned by `IndexSearcher.search`.
* `ScoreDoc` Provides access to each search result in `TopDocs`.

When querying a Lucene index, a `TopDocs` instance, containing an ordered array
of `ScoreDoc`, is returned. The array is ordered by score by default. Lucene
computes a score (a numeric value of relevance) for each document, given a query.
The `ScoreDocs` themselves aren't the actual matching documents, but rather are
references, via an integer document ID, to the documents matched.

In most applications that display search results, users access only the first
few documents, so it isn't necessary to retrieve the actual documents for all
results; you need to retrieve only the documents that will be presented to
the user.

For large indexes, it wouldn't even be possible to collect all matching documents
into available physical computer memory.

    public class BasicSearchingTest extends TestCase {
        public void testTerm() throws Exception {
            IndexSearcher searcher = new IndexSearcher("build/index");

            Term t = new Term("subject", "ant");
            TopDocs docs = searcher.search(new TermQuery(t), 10);
            assertEquals("JDwA", 1, docs.totalHits);

            t = new Term("subject", "junit");
            docs = searcher.search(new TermQuery(t), 10);
            assertEquals(2, docs.totalHits);

            // In a real application, it's best to keep these open and share a
            // single searcher for all queries that need to run.
            searcher.close();

            // Full documents aren't immediately returned;
            // instead, you fetch them on demand.
        }
    }

### Parsing a user-entered query expression: QueryParser

    public void testQueryParser() throws Exception {
        IndexSearcher searcher = new IndexSearcher("build/index");

        // you need to be sure to query on the actual terms indexed.
        QueryParser parser = new QueryParser("contents", new SimpleAnalyzer());

        Query query = parser.parse("+JUNIT +ANT -MOCK");
        TopDocs docs = searcher.search(query, 10);
        assertEquals(1, docs.totalHits);
        Document d = searcher.doc(docs.scoreDocs[0].doc);
        assertEquals("Java Development with Ant", d.get("title"));

        query = new QueryParser("contents", new SimpleAnalyzer())
                                                    .parse("mock OR junit");
        docs = searcher.search(query, 10);
        assertEquals("JDwA and JIA", 2, docs.totalHits);
        searcher.close();
    }

we need to be sure to query on the actual terms indexed. `QueryParser` is the only
searching piece that uses an analyzer. Querying through the API using `TermQuery`
and the others doesn't use an analyzer but does rely on matching terms to
what was indexed.

if we construct queries entirely programmatically we must ensure the `Terms`
included in all of your queries match the `Tokens` produced by the analyzer
used during indexing.

--------------------------------------------------------------------------------
1. [Apache Lucene](http://lucene.apache.org)
