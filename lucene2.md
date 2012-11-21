

### indexing numbers
Lucene can index numeric values by treating them as strings internally. If you
need to index numbers that appear in free-form text, the first thing you should
do is pick an Analyzer that doesn't discard numbers. `WhitespaceAnalyzer` and
`StandardAnalyzer` are two possible candidates. If you  feed them a sentence
such as "Be sure to include Form 1099 in your tax return," they extract 1099 as
a token and pass it on for indexing, allowing you to later search for 1099. On
the other hand, `SimpleAnalyzer` and `StopAnalyzer` discard numbers from the
token stream, which means the search for 1099 won't match any documents.

#### range queries on numbers
When performing range queries, Lucene uses lexicographical values of Fields for
ordering. Consider three numeric Fields whose values are 7, 71, and 20. Although
their natural order is 7, 20, 71, their lexicographical order is 20, 7, 71. A
simple and common trick for solving this inconsistency is to prepad numeric
Fields with zeros, like this: 007, 020, 071. Notice that the natural and the
lexicographical order of the numbers is now consistent.

__NOTE__
When you index Fields with numeric values, prefix them with zeros if you want to
use them for range queries

### Indexing Fields for sorting
If you want to be able to sort results by a `Field` value, you must add it as a
`Field` that is indexed but not analyzed, using `Field.Index.NOT_ANALYZED`.
Fields used for sorting must be convertible to Integers, Floats, or Strings:

    new Field("size", "4096", Field.Store.YES, Field.Index.NOT_ANALYZED);
    new Field("price", "10.99", Field.Store.YES, Field.Index.NOT_ANALYZED);
    new Field("author", "Arthur C. Clark", Field.Store.YES,
                                                    Field.Index.NOT_ANALYZED);

__NOTE__ Fields used for sorting have to be indexed and must contain one token
per document. Typically this means using `Field.Index.NOT_ANALYZED`, but if your
analyzer will always produce only one token, such as `KeywordAnalyzer`, that
will work as well.

### Field truncation
You may want to index only the first 200 words of each document. `IndexWriter`
allows you to truncate per-Field indexing such that only the first N terms are
indexed for an analyzed field. When you instantiate `IndexWriter`, you must pass
in a `MaxFieldLength` instance expressing this limit. `MaxFieldLength` provides
two convenient default instances:

* `MaxFieldLength.UNLIMITED`, which means no truncation will take place, and
* `MaxFieldLength.LIMITED`, which means fields are truncated at 10,000 terms

__NOTE__ Use maxFieldLength sparingly! Since truncation means some documents'
text will be completely ignored, your users will eventually discover that your
search fails to find some documents.

### Optimizing an index
When you index documents, especially many documents or using multiple sessions
with `IndexWriter`, you'll invariably create an index that has many separate
segments. When you search the index, Lucene must search each segment separately
and then combine the results. Applications that handle large indexes should see
search performance improvements by optimizing the index, which merges many
segments down to one or a few segments. An optimized index also consumes fewer
file descriptors during searching.

__NOTE__ Optimizing only improves searching speed, not indexing speed.


* `IndexWriter` exposes 4 methods to optimize:
    + `optimize()` reduces the index to a single segment, not returning until
    the operation is finished.
    + `optimize(int maxNumSegments)`, also known as "partial optimize", reduces
    the index to at most. Typically, the final merge down to one segment is the
    most costly, so optimizing to say 5 segments should be quite a bit faster
    than optimizing down to 1 segment, allowing you to tradeoff optimize time
    versus search speed.
    + `optimize(boolean doWait)` is just like optimize, except if `doWait` is
    false then the call returns immediately while the necessary merges take
    place in the background.
    + `optimize(int maxNumSegments, boolean doWait)` is a partial optimize that
    runs in the background if `doWait` is false.

#### disk IO vs faster searching

* index optimization involves a lot of disk IO, so use it judiciously. It is
a tradeoff of a large one-time cost, for faster searching. If you only
update your index rarely, and do lots of searching between updates, this
tradeoff is worthwhile.

Many users are surprised by how much temporary disk space is required by
optimize. Because Lucene must merge segments together, while the merge is
running, temporary disk space is used to hold the files for the new segment. But
the old segments cannot be removed until the merge is complete. This means,
roughly, you should expect the size of your index to double, temporarily, during
optimize. Furthermore, if you have a reader open on the index before optimize
starts, that reader will tie up another 1X of the index size, so expect your
index to grow to 3X its normal size during optimize. Once optimize completes,
and you've closed all open readers, disk usage will fall back to a lower level
than the starting size of the index.


Analysis
========
An analyzer tokenizes text by performing any number of operations on it, which could include

* extracting words,
* discarding punctuation,
* removing accents from characters,
* lowercasing (also called __normalizing__),
* removing common words,
* reducing words to a root form (__stemming__),
* changing words into the basic form (__lemmatization__).

Using analyzers
---------------
Analysis occurs any time text needs to be converted into terms, which in
Lucene's core is at two spots:

1. during indexing
2. when using `QueryParser` for searching

### Analyzers:

* __`WhitespaceAnalyzer`__, as the name implies, simply splits text into tokens on
   whitespace characters and makes no other effort to normalize the tokens.
* __`SimpleAnalyzer`__, first splits tokens at non-letter characters, then lowercases
   each token. Becareful! This analyzer quietly discards numeric characters.
* __`StopAnalyzer`__, is the same as `SimpleAnalyzer`, except it removes common words
   (called stopwords). By default it removes common words in the English language
   (the, a, etc.), though you can pass in your own set.
* __`StandardAnalyzer`__, is Lucene's __most sophisticated__ core analyzer. It has
    quite a bit of logic to identify certain kinds of tokens, such as company
    names, email addresses, and host names. It also lowercases each token and
    removes stop words.

### Indexing analysis

        Analyzer analyzer = new StandardAnalyzer();
        IndexWriter writer = new IndexWriter(directory, analyzer,
                                IndexWriter.MaxFieldLength.UNLIMITED);


Following creates a tokenized and stored field. Original String value is stored.
However, the output of the designated Analyzer dictates what is indexed.

        new Field(String, String, Field.Store.YES, Field.Index.ANALYZED)

indexing of a document where one field is analyzed and stored, and the
second field is analyzed but not stored:

        Document doc = new Document();
        
        doc.add(new Field( "title", 
                           "This is the title", 
                           Field.Store.YES, 
                           Field.Index.ANALYZED));

        doc.add(new Field( "contents", 
                           "...document contents...", 
                           Field.Store.NO, 
                           Field.Index.ANALYZED));
        
        writer.addDocument(doc);

if an individual document has special analysis needs, the analyzer may be
specified on a per-document basis,

        writer.addDocument(doc, analyzer);

### QueryParser analysis
`QueryParser` must also use an `Analyzer` to parse fragments of the user's textual query.
